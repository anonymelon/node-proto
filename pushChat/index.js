#!/usr/bin/env node

var debug = require('debug')('pushChat');
var app = require('./app');

app.set('port', process.env.PORT || 3100);

var server = app.listen(app.get('port'), function() {
  debug('Express server listening on port ' + server.address().port);
});

var io = require('socket.io')(server);
io.on('connection', function(socket) {
  console.log('chat socket io on connection');
  socket.on('getChannel', function(data) {
    // This assign channel should be handle by applications
    socket.emit('assignChannel', 'pushChatChannel_1');
  });
});
