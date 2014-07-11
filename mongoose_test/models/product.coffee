'use strict'

mongoose = require 'mongoose'
Promise = require 'bluebird'

Promise.promisifyAll mongoose.Model
Promise.promisifyAll mongoose.Model.prototype
Promise.promisifyAll mongoose.Query.prototype
Promise.promisifyAll mongoose.Collection.prototype

ProductSchema = new mongoose.Schema(
  name: String
  price: Number
)

ProductSchema.statics =
  findByName: (name) ->
    @findOne
      name: name
    .execAsync()


module.exports = mongoose.model 'product', ProductSchema

