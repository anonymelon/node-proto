var cluster = require('cluster');
var http = require('http');
var cpuNums = require('os').cpus().length;

if (cluster.isMaster) {
  console.log('master started.......');

  for (var i = 0; i < cpuNums; i++) {
    cluster.fork();
  };

  cluster.on('listening', function(worker, address) {
    console.log('listening: worker ' + worker.process.pid + ', Address: ' + address.address + ":" + address.port);
  });

  cluster.on('exit', function(argument) {
    console.log('worker ' + worker.process.pid + ' died');
  });
} else {
  http.createServer(function (req, res) {
    res.writeHead(200);
    res.end('hello world');
  }).listen(8888);


}
