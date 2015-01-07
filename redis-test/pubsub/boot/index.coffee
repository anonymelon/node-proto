'use strict'

Promise = require 'bluebird'



module.exports = ->
  new Promise((resolve, reject) ->
    require('./redis').start()
  )
