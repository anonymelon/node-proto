'use strict'

StatsD = require('node-statsd').StatsD
client = new StatsD 'localhost', 8125

setInterval () ->
  num = Math.random() * 1000
  client.timing 'my.statsd.local.test', num
  console.log num
, 1000
