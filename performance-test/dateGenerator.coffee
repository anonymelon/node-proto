'use strict'

MongoClient = require('mongodb').MongoClient
ObjectID = require('mongodb').ObjectID

config = require './config'
utils = require './utils'


MongoClient.connect 'mongodb://127.0.0.1:27017/tuisongbao_dev', (err, db) ->
  return console.error err if err
  collection = db.collection('devices')
  count = 0
  for i in [0...10000]
    collection.insert
      a: new ObjectID 'cc70bf51d87f5111e71c3d4e'
      t: utils.createToken()
      u: utils.createToken(20)
      s : 'tps'
      g: [
        "_to_2014 06/06 10:00"
        "_ta_1.5"
        "_tl_上海市,上海市,浦东新区"
        "jeremy"]
    , (err, doc) ->
      console.log err if err
      count = count++

  console.log count

  db.close()
