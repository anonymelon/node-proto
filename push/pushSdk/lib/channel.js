'use strict'

var utils = require('./utils');

module.exports.Channel = Channel;

function Channel(channel, engine) {
  this.name = channel;
  this.engine = engine;
}

Channel.prototype.bind = function(eventName, fn, specifyListener) {
  this.engine._bind(combineEvent.call(this, eventName), fn, specifyListener);
}

Channel.prototype.unbind = function(eventName) {
  this.engine._bind(combineEvent.call(this, eventName));
}

Channel.prototype.trigger = function(eventName, data) {
  this.engine._trigger(this.name, eventName, data);
}

function combineEvent(eventName) {
  return this.name + ':' + eventName;
}
