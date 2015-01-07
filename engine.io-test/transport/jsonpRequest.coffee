'use strict'

CALLBACK_REGEXP = /[\?|&]callback=([a-z0-9_]+)/i
rNewline = /\n/g
rEscapedNewline = /\\n/g

module.exports.get = (url, data, cb) ->
  data or= {}
  # NOTE: Date.now() is not available until IE9
  data.timestamp = new Date().getTime()
  data.callback = "randomFunc_#{ _genRandomNum() }" unless data.callback

  queryPairs = []
  for key, value of data
    queryPairs.push "#{ key }=#{ value }"

  if url.indexOf('?') is -1
    url += '?'
  else
    url += '&'

  url += queryPairs.join '&'

  _getJsonpFunc() url, cb

_genRandomNum = ->
  Math.random().toString().substr(2)

_getJsonpFunc = ->
  loadScript = (url, cb) ->
    script = document.createElement 'script'
    done = false
    script.type = 'text/javascript'
    script.src = url
    script.async = true
    script.onload = script.onreadystatechange = ->
      if not done and (not this.readyState or this.readyState is 'loaded' or this.readyState is 'complete')
        done = true
        script.onload = script.onreadystatechange = null
        script.parentNode.removeChild script if script and script.parentNode
        cb()

    insertAt = document.getElementsByTagName("script")[0]
    insertAt.parentNode.insertBefore script, insertAt

  getCallbackFromUrl = (url, callback) ->
    matches = url.match(CALLBACK_REGEXP)
    return callback new Error("Could not find callback on URL") unless matches
    callback null, matches[1]

  (url, callback) ->
    getCallbackFromUrl url, (err, callbackName) ->
      data = undefined
      originalCallback = window[callbackName]
      return callback(err) if err
      window[callbackName] = (jsonpData) ->
        data = jsonpData

      loadScript url, (err) ->
        err = new Error("Calling to #{ callbackName } did not returned a JSON response \
          Make sure the callback #{ callbackName } exists and is properly formatted.") unless err or data
        if originalCallback
          window[callbackName] = originalCallback
        else
          try
            delete window[callbackName]
          catch ex
            window[callbackName] = undefined
        callback err, data


# TODO: Add jsonp post support with iframe refer engine.io-client pollingJsonp#doWrite()
# exports.post = (url, data, cb) ->

#   _createFormPost url, data, cb

# _createFormPost = (url, data, fn) ->
