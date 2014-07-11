'use strict'

mongoose = require 'mongoose'
Promise = require 'bluebird'

Promise.promisifyAll mongoose.Model
Promise.promisifyAll mongoose.Model.prototype
Promise.promisifyAll mongoose.Query.prototype

GoodsSchema = new mongoose.Schema(
  name: String
  price: Number
)

GoodsSchema.statics =
  findByName: (name) ->
    @findOne
      name: name
    .execAsync()


module.exports = mongoose.model 'goods', GoodsSchema

