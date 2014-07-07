'use strict'

grunt = require 'grunt'

module.exports = (grunt) ->
  grunt.initConfig
    gruntTest:
      script: 'coffee index.coffee'

  grunt.registerTask(
    'logTest',
    'console log content',
    () ->
      console.log 'this is a simple grunt test'
  )

  grunt.registerTask(
    'scriptTest',
    () ->
       grunt.task.run['gruntTest']
  )
