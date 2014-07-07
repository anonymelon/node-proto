'use strict'

agent = require 'superagent'
Promise = require 'bluebird'

Promise.promisifyAll agent.Request.prototype

serverAK = '0GI4cj73UGyNk7t2crlORdBx'
apiUrl = 'http://api.map.baidu.com/geocoder/v2/'

lng = 121.63848131409
lat = 31.230895349134
pois = 0

placeBody =
  ak: serverAK
  output: 'json'
  address: '浦东新区'
  city: '上海市'

locationBody =
  ak: serverAK
  location: "#{lat},#{lng}"
  pois: pois
  output: 'json'


# { province: '江苏省',
#   city: '南通市',
#   district: '如皋市',
#   marker: { lng: 120.63, lat: 32.23 },
#   count: { apns: 0, tps: 1, total: 1 } }


# agent.get(apiUrl)
# .query(placeBody)
# .end (err, res) ->
#   return console.log err if err
#   console.log res.text


# agent.get(apiUrl)
# .query(locationBody)
# .end (err, res) ->
#   return console.log err if err
#   console.log res.text

# agent.get(apiUrl)
# .query(locationBody)
# .endAsync()
# .then (res) ->
#   console.log JSON.parse(res.text)
# .catch (err) ->
#   console.log err

agent.get(apiUrl)
.query
  ak: serverAK
  output: 'json'
  address: '江苏省'
.endAsync()
.then (res) ->
  console.log JSON.parse(res.text)
.catch (err) ->
  console.log err

agent.get(apiUrl)
.query
  ak: serverAK
  output: 'json'
  address: '江苏省,南通市'
.endAsync()
.then (res) ->
  console.log JSON.parse(res.text)
.catch (err) ->
  console.log err


agent.get(apiUrl)
.query
  ak: serverAK
  output: 'json'
  address: '科尔沁区'
.endAsync()
.then (res) ->
  console.log res.text
  ret = JSON.parse(res.text)
  agent.get(apiUrl)
  .query
    ak: serverAK
    output: 'json'
    location: "#{ret.result.location.lat},#{ret.result.location.lng}"
  .endAsync()
  .then (res) ->
    console.log JSON.parse(res.text)
.catch (err) ->
  console.log err



# , Promise.try ->
#     v1LocationCodes = []
#     fs.readFileAsync 'data/locationCode.csv'
#     .then (data) ->
#       locations = data.toString().split "\n"
#       Promise.map [0...locations.length], (i) ->
#         if locations[i]
#           spiltList = locations[i].split ','
#           v1LocationCodes.push(
#             _id: "5315b2a69a0bc26f736#{ _.str.pad i, 5, '0' }"
#             code: spiltList[0]
#             location: spiltList[1]
#           )
#       .then ->
#         V1LocationCode.createAsync v1LocationCodes
