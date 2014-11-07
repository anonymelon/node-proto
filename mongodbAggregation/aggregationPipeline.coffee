'use strict'

mongodb = require 'mongodb'
dbPath = 'mongodb://127.0.0.1:27017/aggregation'

mongodb.MongoClient.connect dbPath, (err, db) ->
  throw err if err
  collection = db.collection 'account'
  collection.aggregate [
    # $match:
    #   status: 'free'
    $group:
      _id: '$name'
      total:
        $sum: '$number'
  ], (err, data) ->
    return console.log err if err
    console.log data
