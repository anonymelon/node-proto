'use strict'

var TSB_PUSH_HOST = 'http://localhost:3000';

function TSBPusher(appKey) {
  this.key = appKey;
  this.socket = io.connect(TSB_PUSH_HOST);
}

TSBPusher.prototype.subscribe = function(channel) {
  this.socket.emit('joinChannel', channel);
};

TSBPusher.prototype.publish = function(data) {
  this.socket.emit('newMessage', data);
};

TSBPusher.prototype.on = function(identify, callback) {
  this.socket.on(identify, callback);
};
