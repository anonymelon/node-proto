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
  }

  TSBPusher.prototype.subscribe = function(channel) {
    if (!this.channels[channel]) {
      this.channels[channel] = new TSBPusher.Channel(channel, this);
    }
    this.socket.emit('joinChannel', channel);
    return this.channels[channel]
  }

  TSBPusher.prototype.bind = function(event, fn) {
    this.socket.on(event, fn);
    this.socket.emit('bindEvent', event);
  }

  TSBPusher.prototype.trigger = function(event, data) {
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
    this.pusher.bind(getChannelEvent(this.name, event), fn);
  }

  Channel.prototype.trigger = function(event, data) {
    this.pusher.trigger(getChannelEvent(this.name, event), data);
  }

  function getChannelEvent(name, event) {
    return name + ':' + event;
  }

  TSBPusher.Channel = Channel;
}).call(this);
