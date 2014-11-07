'use strict'

StatsD = require('node-statsd').StatsD
client = new StatsD 'localhost', 8125

setInterval () ->
  num = Math.random() * 1000
  client.increment 'statsd.test.static.increment', 500
  client.increment 'statsd.test.random.increment', num
  console.log num
, 500


randomTimer = ->
  client.timing 'statsd.test.timing', 500

triggerTime = ->
  clearInterval timer
  setInterval triggerTime, num = Math.random() * 1000

timer = setInterval triggerTime, 1000



