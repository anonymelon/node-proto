'use strict'

crypto = require 'crypto'

exports.createToken = (size=32) ->
    crypto.randomBytes(size)
      .toString('hex')
