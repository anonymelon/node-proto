'use strict'

mongoose = require 'mongoose'
Promise = require 'bluebird'

Promise.promisifyAll mongoose.Model
Promise.promisifyAll mongoose.Model.prototype
Promise.promisifyAll mongoose.Query.prototype

userSchema = new mongoose.Schema(
  name: String
  # tag: [String]
)

userSchema.statics =
  findByName: (name) ->
    @findOne
      name: name
    .execAsync()

  updateAppVersionTagByName: (name, tag) ->
    vtag = "_ta_#{tag}"
    $set = {}
    $set['tag.$'] = vtag

    @findOneAndUpdate
      name: name
      tag: /_ta_.*/
    ,
      { $set }
    .execAsync()

module.exports = mongoose.model 'user', userSchema

