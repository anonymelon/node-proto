'use strict'

mongoose = require 'mongoose'
User = require 'user'

mongoose.connect 'localhost', 'mongooseTest'

foo = new User(
  name: 'jeremy'
  tag: [
    'aaa',
    'bbb',
    '_tl_上海市,上海市,松江区',
    '_ta_1.5']
)

foo.saveAsync()
.then (ret) ->
  console.log 'saved'
.catch (err) ->
  console.log err

User.findByName 'jeremy'
.then (ret) ->
  console.log ret