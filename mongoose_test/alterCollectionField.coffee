'use strict'

mongoose = require 'mongoose'

User = require './models/user'
Product = require './models/product'
settings = require './settings'

mongoose.connect settings.host, settings.database

# Mongoose swallow
# Product.update {}
Product.collection.update {}
  ,
    $rename:
      name:
        'title'
  ,
    multi:
      true
    upsert:
      true
  , (err, ret) ->
    return console.error err if err
    console.log ret
