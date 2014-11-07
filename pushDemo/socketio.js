'use strict'

var sio = require('socket.io');

module.exports = function(server) {
  var io = sio(server);
  io.on('connection', function(socket) {
    socket.on('joinChannel', function(channel) {
      console.log('Socket: ' + socket.id + ' join ' + channel);
      socket.join(channel);
    });

    socket.on('newMessage', function(data) {
      data.id = socket.id;
      socket.broadcast.to(data.channel).emit('newMessage', data);
      console.log(data);
      // io.sockets.in(data.channel).emit('newMessage', data);
    });
  });
}
