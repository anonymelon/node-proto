'use strict'

Promise = require 'bluebird'

server = require './server'

module.exports.start = ->
  Promise.all [
    server.start()
  ]
