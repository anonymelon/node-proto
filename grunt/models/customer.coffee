mongoose = require 'mongoose'

customerSchema = new mongoose.Schema(
  name: String
)

customerSchema.statics =
  findByName: (name, cb) ->
    @find(name: new RegExp(name, 'i'),cb)

  deleteByName: (name, cb) ->
    @findOneAndRemove(name: new RegExp(name, 'i'),cb)

module.exports = mongoose.model 'Customer', customerSchema
