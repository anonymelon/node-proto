'use strict'

mongoose = require 'mongoose'

User = require './models/user'
Product = require './models/product'
Goods = require './models/goods'

settings = require './settings'

mongoose.connect settings.host, settings.database


mongodb = require 'mongodb'
console.log '==========='
console.log mongoose.connection.db
console.log '==========='

Product.find().execAsync()
.then (prods) ->
  prods.forEach (prod) ->
    new Goods(
      name: prod.name
      price: prod.price
    ).saveAsync()
    .then (ret) ->
      console.log ret
