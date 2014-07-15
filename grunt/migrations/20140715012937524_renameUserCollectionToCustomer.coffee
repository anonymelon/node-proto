mongoose = require 'mongoose'

Promise = require 'bluebird'

require '../models/user'

User = mongoose.model 'User'

module.exports =
  requiresDowntime: false

  up: (callback) ->
    User.collection.rename 'customer', (err, newCollection) ->
      if err
        console.error err
        callback()
      console.log newCollection.collectionName
      callback()

  down: (done) ->
    done()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
