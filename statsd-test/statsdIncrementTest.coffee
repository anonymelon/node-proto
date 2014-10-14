'use strict'

StatsD = require('node-statsd').StatsD
client = new StatsD()


setInterval () ->
  client.increment 'increment.test', 10
,
  500


setInterval () ->
  client.increment 'increment.test2', 100
,
  1000

setInterval () ->
  client.increment 'increment.test3', 30
,
  500

