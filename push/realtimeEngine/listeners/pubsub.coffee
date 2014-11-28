'use strict'

logger = require('log4js').getLogger 'realtimeEngine.listeners.pubsub'

module.exports = (io, socket, client)->
  # Subscribe events
  socket.on 'subscribeChannel', (channel) ->
    logger.debug "Subscribe channel: #{ socket.id }, #{ channel }"
    socket.join channel

  socket.on 'unsubscribeChannel', (channel) ->
    logger.debug "Unsubscribe channel: #{ socket.id }, #{ channel }"
    socket.leave channel

  socket.on 'bindEvent', (eventName) ->
    logger.debug "BindEvent: #{ socket.id }, #{ eventName }"
    socket.on eventName, (rawData) ->
      logger.debug "Broadcast to channel: #{ socket.id }, #{ rawData.channel },
      #{ eventName }, #{ rawData.data }"
      data = rawData.data
      # #Broadcast don't send data to sender itself
      # socket.broadcast.to(rawData.channel).emit eventName, data
      # Send Data to all socket in channel, include sender itself
      io.sockets.to(rawData.channel).emit eventName, data

      # Emit engine bind event
      eventNames = eventName.split(':')
      eventNames.splice 1,1
      logger.debug "Broadcast to engine channel: #{ socket.id },
      #{ rawData.channel.split(':')[0] }, #{ eventNames.join(':') }, #{ rawData.data }"
      # socket.broadcast.to(rawData.channel.split(':')[0]).emit eventNames.join(':'), data
      io.sockets.to(rawData.channel.split(':')[0]).emit eventNames.join(':'), data

  socket.on 'unbindEvent', (eventName) ->
    logger.debug "UnbindEvent: #{ socket.id }, #{ eventName }"
    socket.removeAllListeners eventName
