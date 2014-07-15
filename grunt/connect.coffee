mongoose = require 'mongoose'

connection = () ->
  conn = mongoose.connect 'mongodb://localhost:27017/mongooseTest'

module.exports = connection
