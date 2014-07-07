'use strict';


var mongoose = require('mongoose');

mongoose.connect('localhost', 'agendaTest');

var User = require('./models/user');


var names = ['Ahmed', 'Aida', ' Aidan', ' Aila', ' Ailee', ' Aileen', ' Ailene', ' Ailey', ' Aili', ' Ailis']

for (var i in names) {
  new User({
    name: names[i],
    age: Math.round(100 * Math.random())
  }).save(function(err) {
    if (err) return console.error(err);
    console.log('saved')
  })
}

User.findByName('Ahmed', function(err, user) {
  console.log(user);
});


// User.removeByName('Ahmed', function(err, user) {
//   console.log(user);
// });

// User.findByName('Ahmed', function(err, user) {
//   console.log(user);
// });