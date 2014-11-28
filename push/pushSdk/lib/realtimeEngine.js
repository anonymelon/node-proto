'use strice'

var http = require('http');
var sioClient = require('socket.io-client');
var util = require('util');
var Emitter = require('events').EventEmitter;

var Channel = require('./channel').Channel;
var config = require('./config');
var utils = require('./utils');
// constants
var STRIP_COMMENTS = /((\/\/.*$)|(\/\*[\s\S]*?\*\/))/mg;
var ARGUMENT_NAMES = /([^\s,]+)/g;

exports.RealtimeEngine = RealtimeEngine;

function RealtimeEngine(appId, secret, options) {
  options = options || {};
  this.version = '0.2';
  this.appId = appId;
  this.options = options || {};
  this.state = 'initialized';
  this.pendingChannelBindEvents = {};
  this.pendingSubChannels = {};
  this.pendingTriggerEvents = {};
  this.pendingRegProcs = {};
  this.pendingCallProcs = {};
  this.channels = {};
  this.on('connected', function() {
    console.log('connected, resolve pending events');
    // Refine this ugly calls
    resolvePendings.call(this, this.pendingChannelBindEvents, this._bind);
    resolvePendings.call(this, this.pendingSubChannels, this.subscribe);
    resolvePendings.call(this, this.pendingTriggerEvents, this._trigger);
    resolvePendings.call(this, this.pendingRegProcs, this.register);
    resolvePendings.call(this, this.pendingCallProcs, this.call);
  })
  init.call(this, appId, secret);
}

util.inherits(RealtimeEngine, Emitter);
var prototype = RealtimeEngine.prototype;

function init(appId, secret) {
  var self = this;

  var connectOptions = config.server;
  // Refine strategy
  connectOptions.path = connectOptions.path + '?appId=' + appId;
  connectOptions.headers = {
    'Authorization': 'Basic ' + new Buffer(appId + ':' + secret).toString('base64')
  };

  http.get(connectOptions, function(res) {
    res.setEncoding('utf8');
    var chunk = '';
    res.on('data', function(chunkData) {
      chunk += chunkData;
    });
    res.on('end', function() {
      console.log('Socket connection host: ' + JSON.parse(chunk).addrs[0]);
      self.io = sioClient('http://' + JSON.parse(chunk).addrs[0]);
      self.state = 'connected';
      self.io.on('connect', function() {
        self.socketId = this.io.engine.id;
      });
      // TODO Subscribe specify events
      // Subscribe appId channel to receive global events triggered by different channels
      // Doesn't use self.subscribe to avoid colon combine, it can be refine
      self._emit('subscribeChannel', self.appId);

      self.emit('connected');
    });
  });
}

prototype.subscribe = function(channel) {
  if (undefined == this.channels[channel]) {
    channel = combineWithAppId.call(this, channel);
    this.channels[channel] = new Channel(channel, this);
  }
  if (this.state == 'connected') {
    console.log('subscribe channel-----: ' + channel);
    this._emit('subscribeChannel', channel);
  } else {
    this.pendingSubChannels[channel] = utils.sliceArguments(arguments);;
  }
  return this.channels[channel];
}

prototype.unsubscribe = function(channel) {
  delete this.channels[channel];
  // TODO Add connection unconnected state support
  // TODO Remove bind events in channel
  if (this.connection.state == 'connected') {
    console.log('unsubscribe channel: ' + channel);
    this._emit('unsubscribeChannel', channel);
  }
  return this;
}

prototype.bind = function(eventName, cb) {
  this._bind(combineWithAppId.call(this, eventName), cb);
}

prototype.unbind = function(eventName) {
  this._unbind(combineWithAppId.call(this, eventName));
}

prototype._bind = function(eventName, cb, specifyListener) {
  var bindListener = 'bindEvent';
  if (undefined != specifyListener) {
    bindListener = specifyListener;
  }
  if (this.state == 'connected') {
    console.log('bindEvent-----', eventName);
    this._emit(bindListener, eventName);
    this._on(eventName, cb);
  } else {
    this.pendingChannelBindEvents[eventName] = utils.sliceArguments(arguments);
  }
}

prototype._unbind = function(eventName) {
  if (this.state == 'connected') {
    this.io.removeAllListeners(eventName);
    this._emit('unbindEvent', eventName);
  }
}

prototype.trigger = function(channels, eventName, data) {
  var i;
  if (typeof(channels) == 'string') {
    channels = [channels];
  }
  for (i in channels) {
    this._trigger(combineWithAppId.call(this, channels[i]), eventName, data);
  }
}

// This just trigger one event
prototype._trigger = function(channel, eventName, data) {
  if (this.state == 'connected') {
    console.log('triggerEvent----', channel + ':' + eventName, data);
    this._emit(channel + ':' + eventName, {
      channel: channel,
      data: data
    });
  } else {
    // TODO TDB If engine and channel trigger the same event, it will be overide
    this.pendingTriggerEvents[channel + eventName] = utils.sliceArguments(arguments);
  }
}

prototype.channel = function(channel) {
  return this.channels[channel];
}

prototype.allChannels = function() {
  return this.channels;
}

prototype.register = function(procedureName, cb) {
  var self = this;
  var args = getParamNames(cb);
  if (this.state == 'connected') {
    // Emit registerprocedure event
    this._emit('registerProcedure', {
      procedureName: combineProcedure.call(this, 'REG_PROCEDURE', procedureName),
      args: args
    });
    // Listen trans args event to receive call args
    this._on(combineProcedure.call(this, 'TRANS_ARGS', procedureName), function(transArgs) {
      console.log(transArgs, 'get call proc');

      // Run registered function, emit return data event with run result
      var returnData = cb.call(null, transArgs.args);
      console.log(returnData, 'return args');
      self._emit(combineProcedure.call(self, 'RETURN_DATA', procedureName), {
        callSocketId: transArgs.callSocketId,
        data: returnData
      });
    });
  } else {
    this.pendingRegProcs[procedureName] = utils.sliceArguments(arguments);
  }
}

// TODO
prototype.unregister = function() {

}

prototype.call = function() {
  var args = utils.sliceArguments(arguments);
  var procedureName = args[0];
  var callArgs = args[1];
  // if no callback, let it be an empty function
  var callBack = args[2] || function() {};
  if (this.state == 'connected') {
    this._emit('callProcedure', {
      procedureName: combineProcedure.call(this, 'CALL_PROCEDURE', procedureName),
      args: callArgs
    });

    this._on(combineProcedure.call(this, 'TRANS_DATA', procedureName), function(returnData) {
      callBack(returnData);
    });
  } else {
    this.pendingCallProcs[procedureName] = utils.sliceArguments(arguments);
  }
}

// TODO Destroy engine, clear all listeners and events
prototype.destroy = function() {

}

prototype._emit = function(eventName, data) {
  this.io.emit(eventName, data)
}

prototype._on = function(eventName, cb) {
  this.io.on(eventName, cb);
}

function combineProcedure(prefix, procedureName) {
  return prefix + ':' + this.appId + ':' + procedureName;
}

function combineWithAppId(name) {
  return this.appId + ':' + name;
}

function getParamNames(func) {
  var fnStr = func.toString().replace(STRIP_COMMENTS, '');
  var result = fnStr.slice(fnStr.indexOf('(') + 1, fnStr.indexOf(')')).match(ARGUMENT_NAMES);
  if (result === null) {
    result = [];
  }
  return result;
}

function resolvePendings(pendings, cb) {
  var name;
  for (name in pendings) {
    cb.apply(this, pendings[name]);
    delete pendings[name];
  }
}

// TODO use common methods for store pending events
function storePendings(type, resolveFn, key, value) {
  if (undefined == this.pendinds[type]) {
    this.pendinds[type] = {};
  }
  this.pendinds[type]['resolveFn'] = resolveFn;
  this.pendinds[type][key] = value;
}
