'use strict'

redis = require 'redis'
Promise = require 'bluebird'

module.exports.start = ->
  new Promise((resolve, reject) ->
    client = redis.createClient()
    resolve client
  )


