'use strict'

mongodb = require 'mongodb'
# dbPath = 'mongodb://127.0.0.1:27017/aggregation'
dbPath = 'mongodb://127.0.0.1:27017/tuisongbao_dev'

# mongodb.MongoClient.connect dbPath, (err, db) ->
#   throw err if err
#   collection = db.collection 'account'

#   map = ->
#     emit @.name, @.number

#   reduce = (key, value) ->
#     Array.sum value

#   collection.mapReduce map, reduce, {out : {inline: 1}, verbose:true}, (err, results, stats) ->
#     console.log results


mongoAppId = new mongodb.ObjectID 'cb70bf51d87f5111e71c3d4e'

mongodb.MongoClient.connect dbPath, (err, db) ->
  throw err if err
  collection = db.collection 'devices'

  map = () ->
    value =
      tags: []
    for tag in @.g
      if tag.indexOf '_to_' != -1
        value.openTime = tag.slice(4)
      if tag.indexOf '_ta_' != -1
        value.appVersion = tag.slice(4)
      if tag.indexOf '_tl_' != -1
        value.location = tag.slice(4)
      else
        value.tags.push tag

    console.log value

    emit @.s, value

  reduce = (key, value) ->
    # result = {}
    # result[value.appVersion] = Array.sum 1
    # result[value.location] = Array.sum 1
    # result[value.openTime] = Array.sum 1

    # result

    # Array.sum 1

  collection.mapReduce map,
    reduce
  ,
    query: {a: mongoAppId}
    out: 'result'
    # verbose:true
  , (err, results, stats) ->
    return console.log err if err
    console.log results
    console.log stats

