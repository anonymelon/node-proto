'use strict'

module.exports =
  dbName: 'count_test'
  tableSchemas:
    origin: [
        'id varchar(10)'
        'name varchar(255)'
      ]
    compare: [
        'id varchar(10)'
        'name varchar(255)'
      ]
  connConfig:
    host: 'localhost'
    user: 'root'
    password: 'abc123_'
  totalNum: 1000000
  bunketNum: 50000
  deleteIdNum: 10000
  extraAddNum: 10000
