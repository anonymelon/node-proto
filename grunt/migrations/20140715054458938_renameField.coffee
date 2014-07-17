mongoose = require 'mongoose'

require '../models/user'

User = mongoose.model 'User'

module.exports =
  requiresDowntime: false

  up: (callback) ->
    User.collection.update {},
      $rename:
        description:
          'desc'
    ,
      multi:
        true
      upsert:
        true
    , callback

  down: (done) ->
    done()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
