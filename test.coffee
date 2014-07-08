'use strict'
# moment = require 'moment'

# jsonStr =
#   a: 11111111
#   b: 2222222222
#   c: 33333333333

# for k,v of jsonStr
#   console.log k, v

# console.log jsonStr

# console.log moment().format('YYYY-MM-DD HH:mm:ss')

# crypto = require 'crypto'

# createRandomHexString = (size = 24) ->
#   crypto.randomBytes(size / 2).toString('hex')

# console.log createRandomHexString(26)[0...25]

# dic =
#   versions: [{android:'1.7.3',ios: '7.02'}, {ios: '7.02'}]
# for item in dic.versions
#   for k,v of item
#     console.log k, v


# ary = [1,2,3,'4']

# console.log 4 in ary

# console.log require('util').inspect Object, true, 20

# t = {}

# for i in [1..4]
#   if i is 2
#     t.a = 't'
#   if i is 3
#     t.b = 'c'

# console.log t


# al = [
#   1
#   2
#   3
#   4
#   5
# ]

# console.log  al.join ','

testStr = 'localhost/tuisongbao_new_test'


console.log testStr.replace(/\//g, ':27017/')
