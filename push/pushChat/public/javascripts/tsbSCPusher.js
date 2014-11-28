'use strict'
// TODO Temporary here, refine it
function appendSeparator() {
  return Array.prototype.slice.call(arguments).join(':');
}

;
(function() {
  /** Channel object
   *
   * @param {String} appName
   */
  // TODO add appName verification
  function TSBPusher(appName) {
    var options = {
      hostname: 'localhost',
      port: 3000
    };
    this.name = appName;
    this.socket = socketCluster.connect(options);
    this.channels = {};
    this.channel = new TSBPusher.Channel('/', this);
  }

  TSBPusher.prototype.subscribe = function(channel, fn) {
    this.channels[channel] = new TSBPusher.Channel(channel, this, fn);
    return this.channels[channel];
  }

  TSBPusher.prototype._subscribe = function(channel, fn) {
    this.socket.subscribe(channel, fn);
  }

  TSBPusher.prototype._bind = function(event, fn) {
    console.log(event, 'bind==============');
    this.socket.on(event, fn);
  }

  TSBPusher.prototype._trigger = function(event, data) {
    console.log(event, 'trigger==============');
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
  function Channel(name, pusher, fn) {
    this.name = appendSeparator(pusher.name, name);
    this.pusher = pusher;
    this.pusher._subscribe(this.name, fn);
  }

  Channel.prototype.bind = function(event, fn) {
    this.pusher._bind(appendSeparator(this.name, event), fn);
  }
  Channel.prototype.trigger = function(event, data) {
    this.pusher._trigger(appendSeparator(this.name, event), data);
  }

  TSBPusher.Channel = Channel;
}).call(this);
