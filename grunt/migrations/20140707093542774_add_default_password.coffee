module.exports =
  requiresDowntime: false

  up: (callback) ->
    callback()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
