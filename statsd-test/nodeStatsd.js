var StatsD = require('node-statsd').StatsD,
  client = new StatsD();

// Timing: sends a timing command with the specified milliseconds
client.timing('response_time', 42);

// Increment: Increments a stat by a value (default is 1)
client.increment('my_counter');

// Decrement: Decrements a stat by a value (default is -1)
client.decrement('my_counter');

// Gauge: Gauge a stat by a specified amount
client.gauge('my_gauge', 123.45);

// Set: Counts unique occurrences of a stat (alias of unique)
client.set('my_unique', 'foobar');
client.unique('my_unique', 'foobarbaz');

// Incrementing multiple items
client.increment(['these', 'are', 'different', 'stats']);

// Sampling, this will sample 25% of the time the StatsD Daemon will compensate for sampling
client.increment('my_counter', 1, 0.25);

// Using the callback
client.set(['foo', 'bar', 'don'], 42, null, function(error, bytes) {
  //this only gets called once after all messages have been sent
  if (error) {
    console.error('Oh noes! There was an error:', error);
  } else {
    console.log('Successfully sent', bytes, 'bytes');
  }
});

client.socket.on('error', function(error) {
  return console.error("Error in socket: ", error);
});
