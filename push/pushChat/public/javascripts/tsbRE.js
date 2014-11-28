'use strict';

; // Log util used for debug
(function() {
  function log() {
    var message = Array.prototype.slice.call(arguments, 0).join(' ')
    console.log(message);
  }
  this.log = log;
}).call(this)

;
(function() {
  // TODO Refine browser verification strategy
  var TSB_GET_HOST_URL = 'http://devapi.tuisongbao.com/v2/sdk/realtimeEngine/browser/hosts?appId=';

  function RealtimeEngine(appKey, options) {
    options = options || {};
    this.appKey = appKey;
    this.channels = {};
    this.globalEvents = new RealtimeEngine.EventEmiter();
    this.connection = new RealtimeEngine.ConnectionManager();
    this.connection.on('connected', function() {
      log('connection connected');
      this._subscribeAll();
    }, this);
    _init.call(this);
  }

  function _init() {
    var self = this;

    var getHostUrl = TSB_GET_HOST_URL + this.appKey;

    var avaliableHosts = JSON.parse(_httpGet(getHostUrl));
    self.connection.state = 'connected';

    log('get avaliableHosts: ' + avaliableHosts.addrs);
    var connectUrl = avaliableHosts.addrs[0];
    self.connection.socket = io.connect(connectUrl, {
      'force new connection': true
    });
    self.connection.emit('connected');
  }

  function _httpGet(theUrl) {
    var xmlHttp = new XMLHttpRequest();
    xmlHttp.open("GET", theUrl, false);
    xmlHttp.send(null);
    return xmlHttp.responseText;
  }

  var prototype = RealtimeEngine.prototype;

  prototype.subscribe = function(channel) {
    if (undefined == this.channels[channel]) {
      channel = this._combineChannel(channel);
      this.channels[channel] = new RealtimeEngine.Channel(channel, this);
    }
    if (this.connection.state == 'connected') {
      log('subscribe channel' + channel);
      this.connection.socket.emit('subscribeChannel', channel);
    }
    return this.channels[channel]
  }

  prototype.unsubscribe = function(channel) {
    delete this.channels[channel];
    // TODO Add connection unconnected state support
    // TODO Remove bind events in channel
    if (this.connection.state == 'connected') {
      log('unsubscribe channel' + channel);
      this.connection.socket.emit('unsubscribeChannel', channel);
    }
    return this;
  }

  // Handle channel subscribes while connection not ready
  prototype._subscribeAll = function() {
    var channelName;
    for (channelName in this.channels) {
      if (this.channels.hasOwnProperty(channelName)) {
        this.subscribe(channelName);
      }
    }
  }

  prototype._combineChannel = function(channel) {
    return this.appKey + ':' + channel;
  }

  prototype.channel = function(channelName) {
    return this.channels[channelName];
  }

  prototype.allChannels = function() {
    return this.channels;
  }

  this.RealtimeEngine = RealtimeEngine;
}).call(this);

;
(function() {
  function EventEmiter() {
    this.events = {};
  }

  EventEmiter.prototype.on = function(eventName, cb, context) {
    var self = this;
    if (undefined == this.events[eventName]) {
      this.events[eventName] = [];
    }
    this.events[eventName].push({
      fn: cb,
      context: context || window
    });
  }

  EventEmiter.prototype.emit = function(eventName, data) {
    var callbacks = this.events[eventName];
    if (undefined != callbacks || callbacks instanceof Array && callbacks.length != 0) {
      var i;
      for (i = 0; i < callbacks.length; i++) {
        callbacks[i].fn.call(callbacks[i].context || window, data);
      };
    }
  }

  RealtimeEngine.EventEmiter = EventEmiter;
}).call(this);

;
(function() {
  function ConnectionManager() {
    this.state = 'initialized';
    this.events = {}; // TODO Add an util to extends property like events
  }

  ConnectionManager.prototype = RealtimeEngine.EventEmiter.prototype;

  RealtimeEngine.ConnectionManager = ConnectionManager;
}).call(this);

;
(function() {
  function Channel(channel, re) {
    this.name = channel;
    this.re = re;
    this.bindEvents = {};
    this.triggerEvents = {};
    // Listen connection connected eventName, bind and trigger all eventName add before connected
    this.re.connection.on('connected', function() {
      this._bindAll();
      this._triggerAll();
    }, this);
  }

  Channel.prototype = RealtimeEngine.EventEmiter.prototype;

  var prototype = Channel.prototype;

  prototype.bind = function(eventName, cb) {
    eventName = this._combineEvent(eventName)
    if (this.re.connection.state == 'connected') {
      log('bindEvent: ' + eventName);
      this.re.connection.socket.on(eventName, cb);
      this.re.connection.socket.emit('bindEvent', eventName);
    } else {
      if (undefined == this.bindEvents[eventName]) {
        this.bindEvents[eventName] = cb;
      }
    }
    return this;
  }

  prototype.unbind = function(eventName) {
    eventName = this._combineEvent(eventName)
    if (this.re.connection.state == 'connected') {
      log('unbindEvent: ' + eventName);
      this.re.connection.socket.removeAllListeners(eventName);
      this.re.connection.socket.emit('unbindEvent', eventName);
    }
    return this;
  }

  prototype._bindAll = function(cb) {
    var eventName;
    for (eventName in this.bindEvents) {
      if (this.bindEvents.hasOwnProperty(eventName)) {
        this.bind(eventName, this.bindEvents[eventName]);
      }
    }
  }

  prototype.trigger = function(eventName, data) {
    eventName = this._combineEvent(eventName)
    if (this.re.connection.state == 'connected') {
      log('triggerEvent: ' + eventName + '; with data: ' + data);
      this.re.connection.socket.emit(eventName, {
        data: data,
        channel: this.name
      });
    } else {
      if (undefined == this.triggerEvents[eventName]) {
        this.triggerEvents[eventName] = {
          data: data,
          channel: this.name
        }
      }
    }
    return this;
  }

  prototype._triggerAll = function() {
    var eventName;
    for (eventName in this.triggerEvents) {
      if (this.triggerEvents.hasOwnProperty(eventName)) {
        this.trigger(eventName, this.triggerEvents[eventName]);
      }
    }
  }

  prototype._combineEvent = function(eventName) {
    return this.name + ':' + eventName;
  }

  RealtimeEngine.Channel = Channel;
}).call(this);
