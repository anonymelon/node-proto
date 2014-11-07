'use strict'

mongodb = require 'mongodb'
dbPath = 'mongodb://127.0.0.1:27017/tuisongbao_dev'

mongoAppId = new mongodb.ObjectID 'cb70bf51d87f5111e71c3d4e'

mongodb.MongoClient.connect dbPath, (err, db) ->
  throw err if err
  collection = db.collection 'devices'

  map = ->
    emit @.g[3].slice(4), 1

  reduce = (key, value) ->
    Math.floor(Math.random() * 100)

  collection.mapReduce map,
    reduce
  ,
    query: {a: mongoAppId}
    out : {inline: 1}
    verbose:true
  , (err, results, stats) ->
    return console.log err if err
    console.log results
