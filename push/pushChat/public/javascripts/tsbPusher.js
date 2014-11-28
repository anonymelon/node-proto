'use strict'

;
(function() {
  var TSB_PUSH_HOST = 'http://localhost:5000/';
  /** Channel object
   *
   * @param {String} appKey
   */
  // TODO add appKey verification
  function TSBPusher(appKey) {
    this.key = appKey;
    _getAssignHost.apply(this)
    this.channels = {};
    this.channel = new TSBPusher.Channel('/', this);

    function _getAssignHost() {
      console.log(this, '==========');
      var connectSocket = io.connect(TSB_PUSH_HOST + appKey, {
        'force new connection': true // Force create new connection
      });

      connectSocket.emit('assignHost');

      connectSocket.on('assignHost', function(port) {
        console.log(port, '-----------');
        this.connectHost = port;
        this.pushSocket = io.connect('http://localhost:' + port, {
          'force new connection': true
        });
      });
    }
  }

  TSBPusher.prototype.subscribe = function(channel) {
    if (!this.channels[channel]) {
      this.channels[channel] = new TSBPusher.Channel(channel, this);
    }
    this.pushSocket.emit('joinChannel', channel);
    return this.channels[channel];
  }

  TSBPusher.prototype.unSubscribe = function(channel) {
    if (!this.channels[channel]) {
      console.log(channel + ' not subscribed');
    } else {
      this.pushSocket.emit('leaveChannel', channel);
    }
  }

  TSBPusher.prototype.bind = function(event, fn) {
    var pusherEvent = this.channel.name + ':' + event;
    this._bind(pusherEvent, fn);
  }

  TSBPusher.prototype._bind = function(event, fn) {
    this.pushSocket.on(event, fn);
    this.pushSocket.emit('bindEvent', event);
  }

  TSBPusher.prototype._unbind = function(event) {
    this.pushSocket.removeAllListeners(event);
    this.pushSocket.emit('unbindEvent', event);
  }

  TSBPusher.prototype._trigger = function(event, data) {
    this.pushSocket.emit(event, data);
  }

  this.TSBPusher = TSBPusher;
}).call(this);

;
(function() {
  /** Channel object
   *
   * @param {String} name
   * @param {TSBPusher} pusher
   */
  function Channel(name, pusher) {
    this.name = name;
    this.pusher = pusher;
  }

  Channel.prototype.bind = function(event, fn) {
    this.pusher._bind(getChannelEvent(this.name, event), fn);
  }

  Channel.prototype.trigger = function(event, data) {
    data.channel = this.name;
    this.pusher._trigger(getChannelEvent(this.name, event), data);
  }

  Channel.prototype.unbind = function(event) {
    this.pusher._unbind(getChannelEvent(this.name, event));
  }

  function getChannelEvent(appkey, name, event) {
    return appkey + ':' + name + ':' + event;
  }

  TSBPusher.Channel = Channel;
}).call(this);
