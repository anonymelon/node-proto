var RealtimeEngine = require('../').RealtimeEngine;

var appId = 'ba55d7d9472260547a867e00';
var secret = 'bb039c0d83daf11390b373b3';

engine = new RealtimeEngine(appId, secret);
console.log(engine.socketId);

engine.register('myProcedure', function(name, loc, phone) {
  console.log('get remote call args: ', name, loc, phone);
  return Array.prototype.slice.call(arguments).join('-----');
});

var testChannel = engine.subscribe('testChannel');

engine.bind('myEvent', function(data) {
  console.log('engine bind event get data: ', data);
});

testChannel.bind('myEvent', function(data) {
  console.log('server bind myEvent get trigger data: ', data);
});

testChannel.trigger('myEvent', 'aoooooooooo');

testChannel.bind('testEvent', function(data) {
  console.log('server bind testEvent get trigger data: ', data);
});

engine.trigger('testChannel', 'testEvent', 'ahahhaha');


// // TODO unsubscribe, unbind/channel unbind, unregister methods
