'use strict'

mongoose = require 'mongoose'
Promise = require 'bluebird'

Promise.promisifyAll mongoose.Model
Promise.promisifyAll mongoose.Model.prototype
Promise.promisifyAll mongoose.Query.prototype

locationSchema = new mongoose.Schema(
  code: String
  location: String
)

module.exports = mongoose.model 'location', locationSchema, 'location'
