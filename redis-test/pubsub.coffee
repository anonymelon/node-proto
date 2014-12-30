'use strict'

redis = require 'redis'

pubClient = redis.createClient({detect_buffers: true})
subClient = redis.createClient({detect_buffers: true})

subClient.subscribe 'testChannel'
subClient.on 'message', (channel, message) ->
  console.log channel, message, '------------------'


pubClient.publish 'testChannel', 'Hello'


