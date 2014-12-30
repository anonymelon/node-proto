'use strict'

redis = require 'redis'
RedisClient = require('redis').RedisClient

client = redis.createClient();
client.select 7


# client.keys 'ba55d7d9472260547a867e00*', (err, ret) ->
#   return console.error err if err

injectREPrefix = () ->
  methods = ['hset', 'hmget', 'smembers', 'del', 'hget', 'sadd', 'srem']

  methods.forEach (method) ->
    RedisClient.prototype["re#{ method }"] = () ->
      arguments[0] = "re:#{ arguments[0] }"
      console.log(arguments, '***********')
      console.log(method, '!!!!!!!!!!!!')
      RedisClient.prototype[method].apply this, arguments

injectREPrefix()
client.rehmget 'kSuGXJwdrHk1ReTPAAAB', 'appId', 'isServer', (err, ret) ->
  console.log ret, '_______-'

