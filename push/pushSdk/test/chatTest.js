'use strict'

var Chat = require('../').Chat;

var appId = 'ba55d7d9472260547a867e00';
var secret = 'bb039c0d83daf11390b373b3';
var chatChannel = 'myChatChannel';

var options = {
  userId: 'mniawnio12630960hnob',
  conversationId: 'awemnonm1oi23hnughboiw'
}

var myChat = new Chat(appId, secret, chatChannel, options);

myChat.send('What are you doing now?');

myChat.onMessage(function(message) {
  console.log('get message from chat:', message);
  setTimeout(function() {
    myChat.send('My random code is: ' + Math.random() * 10000);
  }, 1000);
});
