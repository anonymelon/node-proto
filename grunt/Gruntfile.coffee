'use strict'

grunt = require 'grunt'

module.exports = (grunt) ->
  grunt.initConfig
    gruntTest:
      script: 'coffee index.coffee'

    migrations:
      path: "#{__dirname}/migrations"
      template: grunt.file.read "#{__dirname}/migrations/_template.coffee" # optional
      mongo: 'mongodb://localhost:27017/mongooseTest'
      ext: "coffee" # default `coffee`

  grunt.loadNpmTasks 'grunt-mongo-migrations'

  grunt.registerTask(
    'logTest',
    'console log content',
    () ->
      console.log 'this is a simple grunt test'
  )

  grunt.registerTask(
    'scriptTest',
    () ->
      require('./logTest')()
  )
