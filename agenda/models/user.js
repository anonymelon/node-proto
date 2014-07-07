'use strict';

var mongoose = require('mongoose');

var userSchema = mongoose.Schema({
  name: String,
  age: Number
})

userSchema.statics = {
  findByName: function(name, cb) {
    this.find({
      name: new RegExp(name, 'i')
    }, function () {
      console.log('hahah');
      cb();
    })
  }
}

userSchema.statics.removeByName = function(name, cb) {
  this.remove({
    name: name
  }, cb);
}



module.exports = mongoose.model('User', userSchema)