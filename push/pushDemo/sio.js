'use strict'

var sio = require('socket.io');

module.exports = function(server) {
  var io = sio(server).of('TestApp');
  io.on('connection', function(socket) {
    var channels = [];
    var bindEvents = [];

    io.sockets.emit('hi', 'everyone');

    socket.on('joinChannel', function(channel) {
      if (channels.indexOf(channel) == -1) {
        channels.push(channel);
        console.log('Socket: ' + socket.id + ' join ' + channel);
        socket.join(channel);
      } else {
        console.log('Socket: ' + socket.id + ' has joined ' + channel);
      }
    });

    socket.on('leaveChannel', function(channel) {
      if (channels.indexOf(channel) != -1) {
        channels.splice(channels.indexOf(channel), 1);
        console.log('Socket: ' + socket.id + ' leave ' + channel);
        socket.leave(channel);
      } else {
        console.log('Socket: ' + socket.id + ' has not join ' + channel);
      }
    });

    socket.on('bindEvent', function(event) {
      console.log('bindEvent: ' + event);
      if (bindEvents.indexOf(event) == -1) {
        bindEvents.push(event);
        socket.on(event, function(data) {
          console.log('broadcast to channel ' + data.channel + ' with data: ' + data);
          socket.broadcast.to(data.channel).emit(event, data);
          io.sockets.emit('/:' + event.split(':')[1], data);
        });
      } else {
        console.log('event: ' + event + ' has binded');
      }
    });

    socket.on('unbindEvent', function(event) {
      if (bindEvents.indexOf(event) != -1) {
        bindEvents.splice(bindEvents.indexOf(event), 1);
        console.log('unbindEvent event: ' + event);
        socket.removeAllListeners(event);
      } else {
        console.log(event + ' has not binded');
      }
    });
  });
}
