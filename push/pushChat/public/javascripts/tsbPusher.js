'use strict'

;
(function() {
  var TSB_PUSH_HOST = 'http://localhost:3000';
  /** Channel object
   *
   * @param {String} appKey
   */
  // TODO add appKey verification
  function TSBPusher(appKey) {
    this.key = appKey;
    this.socket = io.connect(TSB_PUSH_HOST);
    this.channels = {};
    this.channel = new TSBPusher.Channel('/', this);
  }

  TSBPusher.prototype.subscribe = function(channel) {
    if (!this.channels[channel]) {
      this.channels[channel] = new TSBPusher.Channel(channel, this);
    }
    this.socket.emit('joinChannel', channel);
    return this.channels[channel];
  }

  TSBPusher.prototype.unSubscribe = function(channel) {
    if (!this.channels[channel]) {
      console.log(channel + ' not subscribed');
    } else {
      this.socket.emit('leaveChannel', channel);
    }
  }

  TSBPusher.prototype.bind = function(event, fn) {
    var pusherEvent = this.channel.name + ':' + event;
    this.socket.on(pusherEvent, fn);
    this.socket.emit('bindEvent', pusherEvent);
  }

  TSBPusher.prototype._bind = function(event, fn) {
    this.socket.on(event, fn);
    this.socket.emit('bindEvent', event);
  }

  TSBPusher.prototype._unbind = function(event) {
    this.socket.removeAllListeners(event);
    this.socket.emit('unbindEvent', event);
  }

  TSBPusher.prototype._trigger = function(event, data) {
    this.socket.emit(event, data);
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

  function getChannelEvent(name, event) {
    return name + ':' + event;
  }

  TSBPusher.Channel = Channel;
}).call(this);
