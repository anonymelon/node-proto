mongoose = require 'mongoose'

mongoose.connect 'localhost', 'mongooseTest'
User = require '../mongo-migrate/user'


module.exports =
  requiresDowntime: false

  up: (callback) ->
    foo = new User(
        name: 'jeremy'
    )
    foo.save (err) ->
      return console.error(err) if err
      console.log('saved')
    callback()

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
