'use strict'

http = require 'http'

debug = require('debug') 'redis-pubsub'
socketIO = require 'socket.io'

app = require './app'
socketIO = require ''

server = http.createServer app

sio = socketIO server

server.listen 3000

require('./boot')()
