var net = require('net');

clients = []
net.createServer(function(socket) {
  clients.push(socket);
  socket.write("Welcome " + socket.name + "\n");

  socket.on('data', function(data) {
    console.log('Got data: '+data);
  });

  socket.on('end',function() {
    clients.splice(clients.indexOf(socket), 1);
    console.log(socket.name + ' leave');
  });

}).listen(5000);
console.log('Create TCP server listen 5000');
