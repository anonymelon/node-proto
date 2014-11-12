'use strict'

var sio = require('socket.io');

module.exports = function(server) {
  var io = sio(server);

  io.on('connection', function(socket) {

    socket.on('assignNamespace', function(namespace) {
      // Verify namespace
      console.log('11111111111111111');
      var nsp = io.of(namespace);
      // nsp.prototype = io.prototype;
    });

    socket.on('joinChannel', function(channel) {
      console.log('Socket: ' + socket.id + ' join ' + channel);
      socket.join(channel);
      var room = io.sockets.in(channel);
      room.on('join', function() {
        console.log("Someone join the room.");
      });
      room.on('leave', function() {
        console.log("Someone left the room.");
      });
    });

    socket.on('newMessage', function(data) {
      data.id = socket.id;
      console.log(require('util').inspect(io.sockets.in(data.channel), true, 2));
      socket.broadcast.to(data.channel).emit('newMessage', data);
      // io.sockets.in(data.channel).emit('roomEvent', data);
    });

    var bindEvents = [];
    socket.on('bindEvent', function(data) {
      bindEvents.push(data.event);
      console.log('self bind event is: ' + data.event);
      socket.on(data.event, function(data) {
        console.log('get data from self bind: ' + data);
        socket.broadcast.to(data.channel).emit(data.event, data);
        socket.broadcast.emit(data.event, data);
      });
    });
  });
}
