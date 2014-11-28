'use strict'

var RealtimeEngine = require('./realtimeEngine').RealtimeEngine;
var chatEvent = 'chatMessageEvent'
var chatBindEventListener = 'chatBindEvent';

module.exports.Chat = Chat;

//Chat constructor
function Chat(appId, secret, channel, options) {
  this.options = options || {};

  this.appId = appId;
  this.channel = channel;
  this.engine = new RealtimeEngine(appId, secret);
  this.chatChannel = this.engine.subscribe(channel);
}

Chat.prototype.send = function(message) {
  // Package message body
  var messageBody = {
    message: message,
    time: new Date(),
    appId: this.appId,
    channel: this.channel
  };

  // Combine options
  var key;
  for (key in this.options) {
    messageBody[key] = this.options[key];
  }

  this.chatChannel.trigger(chatEvent, messageBody);
}

Chat.prototype.onMessage = function(cb) {
  // Specify chat bind event listener, so that chat message will be stored
  this.chatChannel.bind(chatEvent, cb, chatBindEventListener);
}

Chat.prototype.distroy = function() {
  this.engine.destroy();
  this.engine.unsubscribe(this.channel);
  this.chatChannel.unbind(chatEvent);
}
