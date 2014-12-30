'use strict'

redis = require 'redis'

client = redis.createClient()

client.subscribe 'testChannel'

client.on 'message', (channel, message) ->
  console.log channel, message, '------------------'
