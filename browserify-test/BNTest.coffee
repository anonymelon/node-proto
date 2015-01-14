'use strict'

Env = if process.ENV = 'Browser' then require './browser.coffee' else require './node.coffee'

fs = require 'fs'
os = require 'os'

console.log os.getCPUNums()

excludeModule = if process.ENV = 'Browser' then require './excludeModule.coffee'

sio = require 'socket.io'


excludeModule.exm.excludeMethod()

Env.getInfo()
