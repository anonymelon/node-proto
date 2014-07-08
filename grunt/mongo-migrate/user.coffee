mongoose = require 'mongoose'

userSchema = new mongoose.Schema(
	name: String
)

userSchema.statics =
  findByName: (name, cb) ->
    @find(name: new RegExp(name, 'i'),cb)

  deleteByName: (name, cb) ->
    @findOneAndRemove(name: new RegExp(name, 'i'),cb)

module.exports = mongoose.model 'User', userSchema
