var SDC = require('statsd-client'),
  sdc = new SDC({host: 'localhost', port: 8125, debug: true});


var start = new Date();
setInterval(function () {
  sdc.timing('random.timeout', start);
}, 100 * Math.random());
