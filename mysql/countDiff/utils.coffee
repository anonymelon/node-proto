'use strict'

getInsertItem = (arr) ->
  ("'#{item}'" for item in arr)

module.exports =
  getRandomNumString: (len = 10) ->
    num = Math.floor Math.random() * Math.pow(10, len)
    num.toString()

  getCreateTableQuery: (table, schema) ->
    schema = schema.join ','
    "create table if not exists #{ table } (#{ schema });"

  getInsertQuery: (table, values) ->
    values = ("(#{ getInsertItem(value).join ',' })" for value in values)
    "insert into #{ table } values #{ values.join ',' };"

  getDeleteQuery: (table, ids) ->
    ids = getInsertItem(ids).join ','
    "delete from #{ table } where id in (#{ ids })"
