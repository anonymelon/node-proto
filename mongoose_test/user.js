var mongoose = require('mongoose');

var userSchema = mongoose.Schema({
    name: String,
    age: Number
})


userSchema.statics.findByName = function(name, cb) {
    this.find({
        name: new RegExp(name, 'i')
    }, cb);
}


module.exports = mongoose.model('user', userSchema)