'use strict'

EventEmitter = require('events').EventEmitter

mysql = require 'mysql'
Promise = require 'bluebird'

config = require './config'
utils = require './utils'
eventHandler = new EventEmitter()

getPool = (config) ->
  mysql.createPool config

createDBSQL = "create database if not exists #{ config.dbName };"

conn = mysql.createConnection config.connConfig
Promise.promisifyAll conn
conn.connect()

conn.queryAsync createDBSQL
.spread (rows, fields) ->
  console.log "Database created, affectedRows: #{ rows.affectedRows }"

  config.connConfig.database = config.dbName
  tables = (tableName for tableName, schema of config.tableSchemas)

  Promise.map tables, (tableName) ->
    pool = getPool config.connConfig
    pool.getConnection (err, conn) ->
      return throw err if err
      conn.query utils.getCreateTableQuery(tableName, config.tableSchemas[tableName]), (err, rows, fields) ->
        return throw err if err
        conn.query "alter table #{ tableName } add index (id);", (err, rows, fields) ->
          return throw err if err
          pool.end()
  .then ->
    if config.totalNum <= config.bunketNum
      config.bunketNum = config.totalNum
    poolNums = config.totalNum / config.bunketNum
    successCount = failedCount = 0
    poolStores = []
    deleteIds = []
    startTime = new Date().getTime()

    eventHandler.on 'insertDone', (success, failed) ->
      console.log "Insert done, success: #{ success }, failed: #{ failed }"
      endTime = new Date().getTime()
      console.log "Total time: #{ (endTime - startTime) }ms"
      for pool in poolStores
        pool.end()

    eventHandler.on 'insertError', (table, count) ->
      console.log "Got error when insert into #{ table }, error count: #{ count }"

    # Do some extra steps
    eventHandler.on 'insertDone', ->
      console.log "Start delete origin table record"
      pool = getPool config.connConfig
      pool.getConnection (err, conn) ->
        Promise.all [
          # Delete records from origin
          conn.query (utils.getDeleteQuery 'origin', deleteIds), (err, rows, fields) ->
            return throw err if err
            console.log "Delete done"
        ,
          # Add extra records to compare
          console.log "Add extra data to compare"
          insertValuesArray = []
          for i in [0...config.extraAddNum]
            randomID = utils.getRandomNumString()
            insertValuesArray.push [randomID, 'tester']
          conn.query utils.getInsertQuery('compare', insertValuesArray), (err, rows, fields) ->
            return throw err if err
            console.log "Extra added done"
        ]
        .then ->
          pool.end()

    # TODO: poolNums > 100 may got too many connection error, try limit parallel
    for i in [0...poolNums]
      pool = getPool config.connConfig
      poolStores.push pool
      pool.getConnection (err, conn) ->
        return throw err if err
        # Generate insert query
        insertValuesArray = []
        for i in [0...config.bunketNum]
          randomID = utils.getRandomNumString()
          if deleteIds.length < config.deleteIdNum
            deleteIds.push randomID
          insertValuesArray.push [randomID, 'tester']

        for table in tables
          conn.query utils.getInsertQuery(table, insertValuesArray), (err, rows, fields) ->
            if err
              failedCount += config.bunketNum
              eventHandler.emit 'insertError', table, failedCount
              return throw err
            successCount += rows.affectedRows
            console.log "Current total insert number: #{ successCount }"
            if successCount + failedCount >= config.totalNum * tables.length
              eventHandler.emit 'insertDone', successCount, failedCount
.catch (err) ->
  return console.error err if err
.finally ->
  conn.end()



