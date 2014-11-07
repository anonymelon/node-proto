'use strict'

mongodb = require 'mongodb'
dbPath = 'mongodb://127.0.0.1:27017/aggregation'
names = [
  'Abigail'
  'Ada'
  'Adela'
  'Adelaide'
  'Afra'
  'Agatha'
]

status = [
  'active'
  'blocked'
  'free'
]

mongodb.MongoClient.connect dbPath, (err, db) ->
  throw err if err
  collection = db.collection 'account'

  numberRange = [0...10]

  insertNumber = 0

  for i in [0...100]
    tmpAccount =
      name: getRandomItem names
      number: getRandomItem numberRange
      status: getRandomItem status

    collection.insert tmpAccount, (err, data) ->
      return console.error err if err

getRandomItem = (list) ->
  list[Math.floor(Math.random() * list.length)]
