'use strict'

var engine = require('engine.io');
var http = require('http').createServer().listen(5000);
var server = engine.attach(http);

server.on('connection', function (socket) {
  socket.on('message', function(data){
    console.log('Got data: -----',data)
    socket.send('world');
  });
  socket.on('close', function(){ });
});



