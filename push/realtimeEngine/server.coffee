'use strict'

logger = require('log4js').getLogger 'realtimeEngine.server'
Promise = require 'bluebird'
socketIO = require 'socket.io'
redis = require 'socket.io-redis'

counter = require('../cluster/monitor').counter
client = require('../lib/redisConnPool').getNonBlocking()

pubsubListener = require './listeners/pubsub'
rpcListener = require './listeners/rpc'
chatListener = require './listeners/chat'

exports.start = () ->
  new Promise((resolve, reject) ->
    port = CONFIG.realtimeEngine.serverAddr.split(':')[1]
    io = socketIO.listen port
    logger.info 'Started', { port }

    io.adapter redis
      host: CONFIG.redis.host
      port: CONFIG.redis.port
      db: CONFIG.redis.db

    #TODO Add authorization here
    io.use (socket, next) ->
      next()

    initListeners(io)
    resolve()
  )

initListeners = (io) ->
  io.on 'connection', (socket) ->
    logger.debug "Socket connected: #{ socket.id } "
    counter.inc 'sockets'

    socket.on 'disconnect', ->
      logger.debug "Disconnect: #{ socket.id }"
      counter.inc 'sockets', -1
      # TODO Refine those redis socket cleanups
      client.smembers "regproc:#{ socket.id }", (err, procs) ->
        for proc in procs
          logger.debug "Clean up regprocs: #{ proc }"
          client.srem proc, socket.id
      client.del "regproc:#{ socket.id }"

    pubsubListener io, socket, client
    rpcListener io, socket, client
    chatListener io, socket, client
