'use strict'

utils = require 'util'

# •g （全文查找）
# •i （忽略大小写）
# •m （多行查找）


oppositeStr = '_tl_上海市_tl_,上海市,松江区'
testStr = '_tl_上海市,上海市,松江区'


re = new RegExp('^_tl_*', 'ig')

console.log oppositeStr.split(re)
console.log testStr.split(re)
