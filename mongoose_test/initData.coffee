'use strict'

mongoose = require 'mongoose'

User = require './models/user'
Product = require './models/product'
settings = require './settings'

mongoose.connect settings.host, settings.database

userA = new User(
  name: 'jeremy'
  # tag: [
  #   'aaa',
  #   'bbb',
  #   '_tl_上海市,上海市,松江区',
  #   '_ta_1.5']
)

prodA = new Product(
  name: 'Air Force'
  price: 599
)

userA.saveAsync()
.then (ret) ->
  console.log ret
# .then ->
#   User.findByName 'jeremy'
# .then (ret) ->
#   console.log ret
.catch (err) ->
  console.log err

prodA.saveAsync()
.then (ret) ->
  console.log ret
.catch (err) ->
  console.log err
