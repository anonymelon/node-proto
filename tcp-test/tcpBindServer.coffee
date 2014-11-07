'use strict'

eventEmitter = require('events').EventEmitter

TCP = process.binding('tcp_wrap').TCP
util = require 'util'

# console.log util.inspect TCP, true, 1

class TCPServer
  constructor: ->
    eventEmitter.call this
    console.log 'constructor'

  test: ->
    console.log 'test method'

  listen: (port)->
    # @_handle = new TCP() unless @_handle
    # @_handle.onconnection = onConnection
    # @_handle.bind '0.0.0.0', port

    # r = @_handle.listen backlog
    # if r
    #   @_handle.close()
    #   @_handle = null

    #   error = errnoException process._errno, 'listen'
    #   @emit 'error', error
    # else
    #   @emit 'listening'

util.inherits TCPServer, eventEmitter

TCPServer::listen = (port)->
  console.log port

server = new TCPServer()
server.listen(3000)

server.on 'test', (data) ->
  console.log data

server.emit 'test', '------------'


