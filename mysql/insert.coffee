'user strict'

#db: count_test

# table:
# origin:
#   id: varchar(255) # static
#   name: varchar(255)

# compare: # copy of origin/ insert random data
#   id: varchar(255)
#   name: varchar(255)

dbName = 'count_test'
originTable = 'orgin'
compareTable = 'compare'

createDBSQL = "create database if not exists #{ dbName };"
dropDBSQL = "drop database #{ dbName };"

createOriginTableSchemaSQL = "
create table if not exists #{ originTable } (
  id varchar(10),
  name varchar(255)
);
"

createCompareTableSchemaSQL = "
create table if not exists #{ compareTable } (
  id varchar(10),
  name varchar(255)
);
"
insertSQL = "insert into #{ originTable } values (1111111111, 'tester')"

mysql = require 'mysql'

conn = mysql.createConnection
  host: 'localhost'
  user: 'root'
  password: 'abc123_'
  database: dbName

conn.connect();

execQuery = (query, cb) ->
  conn.query query, (err, rows, fields) ->
    return cb err if err
    cb null, rows, fields

insertData = (table, value, cb) ->
  value = value.join ','
  query = "insert into #{ table } values (#{ JSON.stringify(value) });"
  console.log query, '================'
  execQuery query, cb

execQuery createDBSQL, (err, rows, fields) ->
  return console.error err if err
  console.log "create db rows: #{ rows }"
  console.log "create db fields: #{ fields }"

execQuery createOriginTableSchemaSQL, (err, rows, fields) ->
  return console.error err if err
  console.log "createOriginTableSchemaSQL rows: #{ rows }"
  console.log "createOriginTableSchemaSQL fields: #{ fields }"

execQuery createCompareTableSchemaSQL, (err, rows, fields) ->
  return console.error err if err
  console.log "createCompareTableSchemaSQL rows: #{ rows }"
  console.log "createCompareTableSchemaSQL fields: #{ fields }"

insertData originTable, [1111111111, 'tester'], (err, rows, fields) ->
  return console.error err if err
  console.log "insertData rows: #{ rows }"
  console.log "insertData fields: #{ fields }"

