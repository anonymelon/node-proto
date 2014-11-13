#!/usr/bin/env node

var debug = require('debug')('pushDemo');
var cluster = require('cluster');
var app = require('./app');
// var numCPUs = require('os').cpus().length;
var numCPUs = 5;

app.set('port', process.env.PORT || 3000);
if (cluster.isMaster) {
  console.log("master start...");

  // Fork workers.
  for (var i = 0; i < numCPUs; i++) {
    cluster.fork();
  }

  cluster.on('listening', function(worker, address) {
    console.log('listening: worker ' + worker.process.pid + ', Address: ' + address.address + ":" + address.port);
  });

  cluster.on('exit', function(worker, code, signal) {
    console.log('worker ' + worker.process.pid + ' died');
  });
} else {
  var server = app.listen(app.get('port'), function() {
    debug('Express server listening on port ' + server.address().port);
  });

  require('./sio')(server);
}
