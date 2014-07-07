Promise = require 'bluebird'

Promise.map [0...5], (v, i) ->
  return Promise.reject new Error('haha') if i is 2
  v
.then (ret) ->
  console.log ret
.catch (err) ->
  console.log err