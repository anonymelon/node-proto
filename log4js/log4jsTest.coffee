'use strict'

log4js = require 'log4js'
# log4js.loadAppender 'file'
log4js.loadAppender 'console'

log4js.addAppender(log4js.appenders.console,'log4jsconsole');
logger = log4js.getLogger('log4jsconsole')
logger.debug "=======11111111111111================"


log4js.loadAppender 'file'

log4js.addAppender(log4js.appenders.file('test.log'),'log4jsfile');
logger = log4js.getLogger('log4jsfile')
logger.debug "=======2222222222222222222================"
logger.debug "=======2222222222222222222================"


logger = log4js.getLogger('log4jsconsole')
logger.debug "=======333333333333333333================"


# # log4js = require 'log4js'
# # log4js.loadAppender 'console'



# console.log require('util').inspect logger, true, 20

# console.log logger
