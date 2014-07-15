mongoose = require 'mongoose'

user = require '../models/user'

User = mongoose.model 'User'

mongoose.set 'debug', true

module.exports =
  requiresDowntime: false


  up: (callback) ->
    # foo = new User(
    #     name: 'jeremy'
    # )
    # foo.save (err) ->
    #   return console.error(err) if err
    #   console.log('saved')
    #   callback()
    User.collection.update {},
      $set:
        description: 'Add description here'
    ,
      upsert:
        true
      multi:
        true
    , callback


  down: (done) ->
    User.deleteByName(
      'jeremy',
      (err, data) ->
        console.log data
    )
    done()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
