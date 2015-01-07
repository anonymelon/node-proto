'use strict'

url = require 'url'
Transport = require('engine.io-client/lib/transports')['polling']

URL = 'http://devapi.tuisongbao.com/v2/sdk/engine/server'

# oldOnData = Transport.prototype.onData
# Transport.prototype.onData = (data) ->
#   console.log data, '=================='
#   oldOnData(data)

class Ajax
  @get: (urlStr, data, cb) ->
    data or= {}
    # NOTE: Date.now() is not available until IE9
    data.timestamp = new Date().getTime()

    queryPairs = []
    for key, value of data
      queryPairs.push "#{ key }=#{ value }"

    if urlStr.indexOf('?') is -1
      urlStr += '?'
    else
      urlStr += '&'
    urlStr += queryPairs.join '&'
    urlObj = url.parse urlStr

    opts =
      port: urlObj.port
      path: urlObj.path
      hostname: urlObj.hostname
      query: data
      data: data
      jsonp: true
      forceJSONP: true

    console.log(opts, '@@@@@@@@@@@')
    transport = new Transport(opts)
    transport.poll()
    cb null, 'done'




  @post: (urlStr, data, cb) ->

  @jsonpGet: (urlStr, data, cb) ->
    opts =
      jsonp: true
      forceJSONP: true


Ajax.get URL, {appId: 'ab3d5241778158b2864c0852'},
  (err, ret) ->
    console.log ret, '+++++++++++++++=='
