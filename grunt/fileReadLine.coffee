'user strict'

fs = require 'fs'

ret = fs.readFileSync('./javaScript.md').toString()

console.log ret, '==========='

console.log ret.split('\n')[0].split(' ')[1]
