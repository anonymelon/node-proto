'use strict'

# mongodb = require 'mongodb'

# MongoClient = mongodb.MongoClient

# settings = require './settings'

# MongoClient.connect "mongodb://#{ settings.host }:27017/#{ settings.database }"
#   ,
#     (err, db) ->
#       return console.error err if err
#       prodCollection = db.collection 'goods'
#       prodCollection.rename 'products', (err, collection) ->
#         return console.error err if err
#         console.log "after rename, collection name is #{ collection.collectionName }"

mongoose = require 'mongoose'

User = require './models/user'
Product = require './models/product'

settings = require './settings'

mongoose.connect settings.host, settings.database

Product.collection.rename 'products'
.then (collection) ->
  console.log "after rename, collection name is #{ collection.collectionName }"
.catch (err) ->
  console.error err


