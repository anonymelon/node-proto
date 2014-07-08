module.exports =
  requiresDowntime: false

  up: (callback) ->
    callback()

  down: (done) ->
    done()

  test: ->
    describe 'up', ->
      before ->
      after ->
      it 'works'
