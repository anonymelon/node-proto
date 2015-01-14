'use strict'

_getXHR = ->
  try
    return new XDomainRequest() if window.XDomainRequest
  try
    return new XMLHttpRequest() if window.XMLHttpRequest
  # TODO: Test ActiveXObject in IE5/6/7
  # xdomain = opts.xdomain
  # unless xdomain
  #   try
  #     return new ActiveXObject('Microsoft.XMLHTTP')

_request = (method, url, headers = {}, data, cb) ->
  hasXDomainRequest = if window.XDomainRequest then true else false
  xhr = _getXHR()
  xhr.open method, url, true
  unless hasXDomainRequest
    for name, value of headers
      xhr.setRequestHeader name, value

  xhr.onload = ->
    # XDomainRequest doesn't have readyState and status
    unless hasXDomainRequest
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

exports.get = (url, cb) ->
  _request 'GET', url, null, null, cb

exports.post = (url, data, cb) ->
  headers =
    'Content-Type': 'application/json'

  data = JSON.stringify data

  _request 'POST', url, headers, data, cb
