'use strict'

mongoose = require 'mongoose'

User = mongoose.model 'User'

module.exports =
  requiresDowntime: false

  up: (done) ->
    # If you need add a field not defined in mongoose schema, use model_name.collection
    User.collection.update {}
    ,
      $set:
        description: 'Add description here'
    ,
      upsert: false
      multi: true
    , done
    # Modify provider to remote
    # User.update {}
    # ,
    #   $set:
    #     provider: 'remote'
    # ,
    #   upsert: false
    #   multi: true
    # , done

  down: (done) ->
    # Remove user description field
    User.collection.update {}
    ,
      $unset:
        description: true
    ,
      upsert: false
      multi: true
    , done

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
