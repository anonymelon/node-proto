cluster = require("cluster")
http = require("http")
# numCPUs = require("os").cpus().length
numCPUs = 5
if cluster.isMaster
  i = 0
  for i in [0..numCPUs]
    cluster.fork()

  cluster.on 'fork', (worker) ->
    console.log 'forked worker ' + worker.process.pid
  cluster.on "listening", (worker, address) ->
    console.log "worker " + worker.process.pid + " is now connected to " + address.address + ":" + address.port
  cluster.on "exit", (worker, code, signal) ->
    console.log "worker " + worker.process.pid + " died"
else
  app = require("express")()
  server = require("http").createServer(app)
  io = require("socket.io").listen(server)
  redis = require('socket.io-redis')
  io.adapter(redis({ host: 'localhost', port: 6379 }))
  server.listen 8000
  app.get "/", (req, res) ->
    res.sendFile(__dirname + '/index.html');
  io.sockets.on "connection", (socket) ->
    console.log 'socket call handled by worker with pid ' + process.pid
    setInterval ->
      socket.emit("news", hello: "world")
    , 1000
