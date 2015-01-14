'use strict'

callbackRegExp = /[\?|&]callback=([a-z0-9_]+)/i

module.exports.get = (url, cb) ->
  _getJsonpFunc() url, cb

# Refer: https://github.com/bermi/jsonp-client
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

    insertAt = document.getElementsByTagName('script')[0]
    insertAt.parentNode.insertBefore script, insertAt

  getCallbackFromUrl = (url, callback) ->
    matches = url.match callbackRegExp
    return callback new Error('Could not find callback on URL') unless matches
    callback null, matches[1]

  (url, callback) ->
    getCallbackFromUrl url, (err, callbackName) ->
      return callback(err) if err
      data = undefined
      originalCallback = window[callbackName]
      window[callbackName] = (jsonpData) ->
        data = jsonpData

      loadScript url, (err) ->
        error = new Error("Calling to #{ callbackName } did not returned a JSON response \
          Make sure the callback #{ callbackName } exists and is properly formatted.") unless err or data
        if originalCallback
          window[callbackName] = originalCallback
        else
          try
            # IE7/8 will got error, so catch and resolve it
            delete window[callbackName]
          catch err
            window[callbackName] = undefined

        callback error, data
