'use strict'

_getXHR = (opts = {}) ->
  xdomain = opts.xdomain
  try
    return new XDomainRequest() if window.XDomainRequest
  try
    return new XMLHttpRequest() if window.XMLHttpRequest
  unless xdomain
    try
      return new ActiveXObject("Microsoft.XMLHTTP")

_request = (method, url, headers = {}, data, cb) ->
  isIE8 = if window.XDomainRequest then true else false
  xhr = _getXHR()
  xhr.open method, url, true
  unless isIE8
    for name, value of headers
      xhr.setRequestHeader name, value

  xhr.onload = ->
    unless isIE8
      return if xhr.readyState isnt 4
      return cb new Error("Unexpected response, status: #{ xhr.status }") if xhr.status isnt 200

    try
      responseJSON = JSON.parse xhr.responseText
    catch err
      return cb err

    cb null, responseJSON

  xhr.onerror = ->
    cb new Error("Unexpected response, status: #{ xhr.status }")

  try
    xhr.send data
  catch err
    cb err

exports.get = (url, data, cb) ->
  data or= {}
  data.timestamp = new Date().getTime()

  queryPairs = []
  for key, value of data
    queryPairs.push "#{ key }=#{ value }"

  if url.indexOf('?') is -1
    url += '?'
  else
    url += '&'

  url += queryPairs.join '&'

  _request 'GET', url, null, null, cb


exports.post = (url, data, cb) ->
  headers =
    'Content-Type': 'application/json'

  data = JSON.stringify data

  _request 'POST', url, headers, data, cb
