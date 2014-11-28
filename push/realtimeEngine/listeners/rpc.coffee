'use strict'

logger = require('log4js').getLogger 'realtimeEngine.listeners.rpc'

module.exports = (io, socket, client) ->
  # TODO Store register procedures, provide list api for clients
  # Procedure Events
  socket.on 'registerProcedure', (registerProfile) ->
    logger.debug "RegisterProcedure: #{ registerProfile.procedureName }"

    # Store procedure with appId
    regProcPaths = registerProfile.procedureName.split(':')

    eventName = regProcPaths.slice(1,3).join(':')

    client.sadd "regproc:#{ regProcPaths[1] }:#{ regProcPaths[2] }", socket.id
    # Store socket' register procedure for cleanup
    client.sadd "regproc:#{ socket.id }", "regproc:#{ regProcPaths[1] }:#{ regProcPaths[2] }"

    socket.on "RETURN_DATA:#{ eventName }", (returnData) ->
      socket.broadcast.to(returnData.callSocketId).emit "TRANS_DATA:#{ eventName }",
        returnData.data

  socket.on 'unregisterProcedure', (unretProfile) ->
    # TODO

  socket.on 'callProcedure', (callProfile) ->
    logger.debug "CallProcedure name and args: #{ callProfile.procedureName }, #{ callProfile.args }"

    callProcPaths = callProfile.procedureName.split(':')
    eventName = callProcPaths.slice(1,3).join(':')

    client.smembers "regproc:#{ callProcPaths[1] }:#{ callProcPaths[2] }", (err, ret) ->
      # TODO Change select socketId strategy
      # Here just select first procedure listener's socketId
      targetSocketId = ret[0]
      logger.debug "TargetSocketId: #{ targetSocketId }"
      # TODO Return not match procedure error message
      if targetSocketId
        socket.broadcast.to(targetSocketId).emit "TRANS_ARGS:#{ eventName }",
          args: callProfile.args
          callSocketId: socket.id

    socket.on "WAIT_RETURN:#{ eventName }", (returnData) ->
      logger.debug "ReturnData: #{ returnData }"

      socket.emit "TRANS_DATA:#{ eventName }", returnData
