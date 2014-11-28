var RealtimeEngine = require('../').RealtimeEngine;

var appId = 'ba55d7d9472260547a867e00'
var secret = 'bb039c0d83daf11390b373b3'

engine = new RealtimeEngine(appId, secret);

engine.call('myProcedure', ['jeremy', 'Sh', '123'], function(data) {
  console.log('get remote call result: ', data);
});

var testChannel = engine.subscribe('testChannel');

testChannel.bind('myEvent', function(data) {
  console.log('get trigger data in clientTest', data);
});

testChannel.trigger('myEvent', 'what are you looking for');
