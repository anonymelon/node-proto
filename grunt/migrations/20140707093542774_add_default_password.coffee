mongoose = require 'mongoose'

mongoose.connect 'localhost', 'mongooseTest'

user = require '../mongo-migrate/user'

User = mongoose.model 'User'


module.exports =
  requiresDowntime: false

  up: (callback) ->
    # foo = new User(
    #     name: 'jeremy'
    # )
    # foo.save (err) ->
    #   return console.error(err) if err
    #   console.log('saved')

    User.update(
      {},
      {$set: {'description': 'Add description here'}},
      {upsert:false, multi:true}
    ).exec()
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
