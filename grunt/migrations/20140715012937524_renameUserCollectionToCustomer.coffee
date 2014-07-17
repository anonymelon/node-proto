mongoose = require 'mongoose'

require '../models/user'
require '../models/customer'

User = mongoose.model 'User'
Customer = mongoose.model 'Customer'

module.exports =
  requiresDowntime: false

  up: (callback) ->
    User.collection.rename 'customers', (err, newCollection) ->
      if err
        console.error err
        return callback()
      console.log newCollection.collectionName
      callback()

  down: (done) ->
    Customer.collection.rename 'user', (err, newCollection) ->
      if err
        console.error err
        done()
      console.log newCollection.collectionName
      done()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
