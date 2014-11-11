'use strict'

var sio = require('socket.io');

module.exports = function(server) {
  var io = sio(server);
  io.on('connection', function(socket) {
    // var channel = '';
    socket.on('joinChannel', function(channel) {
      this.channel = channel;
      console.log('Socket: ' + socket.id + ' join ' + channel);
      socket.join(channel);
    });

    socket.on('bindEvent', function(event) {
      console.log('bindEvent: ' + event);
      socket.on(event, function(data) {
        console.log('bind data: ' + data);
        socket.broadcast.to(this.channel).emit(event, data);
      });
    });
  });
}
