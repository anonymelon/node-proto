'use strict'

async = require 'async'
agent = require 'superagent'
fs = require 'fs'

locations = require './locations'

serverAK = '0GI4cj73UGyNk7t2crlORdBx'
apiUrl = 'http://api.map.baidu.com/geocoder/v2/'

asyncCall = (location, callback) ->
  agent.get(apiUrl)
  .query
    ak: serverAK
    output: 'json'
    address: location
  .end (err, res) ->
    return if res?.text or ret.status != 0 or res.results?.length is 0
    ret = JSON.parse(res.text)
    agent.get(apiUrl)
    .query
      ak: serverAK
      output: 'json'
      location: "#{ret.result.location.lat},#{ret.result.location.lng}"
    .end (err, res) ->
      res = JSON.parse(res.text)
      return if res?.text or ret.status != 0 or res.results?
      ac = res.result.addressComponent
      locationObj =
        location:
          type: 'Point'
          coordinates: [res.result.location.lng, res.result.location.lat]
        city: ac.city
        district: ac.district
        province: ac.province
        address: "_tl_#{ ac.province },#{ ac.city },#{ ac.district }"
      fs.appendFile 'test.json', JSON.stringify(locationObj) + ",\n"
  callback()

queue = async.queue asyncCall, 10

queue.drain = () ->
  console.log("Done");

queue.push(locations);

queue.concurrency = 20;


