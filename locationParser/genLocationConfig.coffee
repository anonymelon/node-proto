'use strict'

agent = require 'superagent'
Promise = require 'bluebird'
fs = require 'fs'

locations = require './locations'

Promise.promisifyAll agent.Request.prototype
Promise.promisifyAll fs

serverAK = '0GI4cj73UGyNk7t2crlORdBx'
apiUrl = 'http://api.map.baidu.com/geocoder/v2/'

chop = (arr, step) ->
  arr.slice i, i + step for v, i in arr when i % step is 0


parsedLocations = []

fs.appendFileAsync 'test.json', '[' + "\n"
.then ->
  Promise.reduce chop(locations, 100), (memo, locations) ->
    Promise.map locations, (location) ->
      console.log location, '=================='
      agent.get(apiUrl)
      .query
        ak: serverAK
        output: 'json'
        address: location
      .endAsync()
      .then (res) ->
        ret = JSON.parse(res.text)
        return if ret.status != 0 or res.results?.length is 0
        agent.get(apiUrl)
        .query
          ak: serverAK
          output: 'json'
          location: "#{ret.result.location.lat},#{ret.result.location.lng}"
        .endAsync()
        .then (res) ->
          res = JSON.parse(res.text)
          return if ret.status != 0 or res.results?
          ac = res.result.addressComponent
          locationObj =
            location:
              type: 'Point'
              coordinates: [res.result.location.lng, res.result.location.lat]
            city: ac.city
            district: ac.district
            province: ac.province
            address: "_tl_#{ ac.province },#{ ac.city },#{ ac.district }"
        .then (locationObj) ->
          return unless locationObj
          fs.appendFile 'test.json', JSON.stringify(locationObj) + ",\n"
  , 0
.then ->
  fs.appendFileAsync 'test.json', ']' + "\n"
.then ->
  console.log 'done'
  # fs.writeFileAsync 'locations.json', JSON.stringify(parsedLocations, null, 4)
# .catch (err) ->
#   console.error err
