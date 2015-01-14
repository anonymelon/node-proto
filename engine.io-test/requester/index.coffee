'use strict'

jsonpRequest = require './jsonpRequest.coffee'
xmlHttpRequest = require './xmlHttpRequest.coffee'
Util = require './util.coffee'

# TODO: Search and test the exactly version
# XMLHttpRequest/XDomainRequest support config
browserSupports =
  chrome:
    minVersion: 0
  firefox:
    minVersion: 0
  safari:
    minVersion: 0
  msie:
    minVersion: 8

class Requester
  @_parseGetUrl: (url, data) ->
    data.timestamp = new Date().getTime()

    queryPairs = []
    for key, value of data
      queryPairs.push "#{ key }=#{ value }"

    if url.indexOf('?') is -1
      url += '?'
    else
      url += '&'

    url += queryPairs.join '&'

  @get: (url, data, cb, opts = {}) ->
    data or= {}
    needJSONP = false

    if opts.forceJSONP
      needJSONP = true
    else
      browserInfo = Util.checkBrowser()
      needJSONP = true unless parseFloat(browserInfo.versionNumber) >= browserSupports[browserInfo.browser]?.minVersion

    if needJSONP
      # Create a random callback method to avoid cache
      data.callback = "#{ Util.getRandomStr() }" unless data.callback
      url = @_parseGetUrl url, data
      jsonpRequest.get url, cb
    else
      url = @_parseGetUrl url, data
      xmlHttpRequest.get url, cb

  @post: (url, data, cb, opts) ->
    xmlHttpRequest.post url, data, cb

module.exports = Requester
