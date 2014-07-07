'use strict'

request = require 'superagent'
url = 'http://www.baidu.com'

request.get url
.end (data) ->
  console.log data.statusCode
