var mongoose = require('mongoose');
var User = require('user')

mongoose.connect('localhost', 'mongoose');

// var foo = new User({
//     name: 'bar'
// })
// console.log(foo.name)

// foo.save(function(err) {
//     if (err) return console.error(err);
//     console.log('saved')
// })
User.findByName('bar', function(err, user) {
    console.log(user);
});