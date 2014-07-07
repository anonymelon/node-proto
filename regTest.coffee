'use strict'

mongoose = require 'mongoose'
User = require 'user'

mongoose.connect 'localhost', 'mongooseTest'

appVersion = '1.0'

User.updateAppVersionTagByName 'jeremy', appVersion
.then (ret) ->
  console.log ret
.catch (err) ->
  console.log err


User.findByName 'jeremy'
.then (ret) ->
  console.log ret
.catch (err) ->
  console.log err
