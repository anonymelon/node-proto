'use strict'

nodemailer = require 'nodemailer'
markdown = require('nodemailer-markdown').markdown()
Promise = require 'bluebird'



settings = require './settings'

mailOptions =
  from: settings.transporter.auth.user
  to: settings.receivers.join(',')
  subject: 'Hello ✔'
  # text: 'Hello world ✔'
  # html: 'Hello world ✔'
  markdown: '# Hello world!\n\nThis is a **markdown** message'

transporter = nodemailer.createTransport settings.transporter
Promise.promisifyAll transporter

transporter.use 'compile', markdown
# transporter.sendMail mailOptions, (error, info) ->
#   return console.log error if error
#   console.log "Message sent: #{ info.response }"

transporter.sendMailAsync mailOptions
.then (info)  ->
  console.log "Message sent: #{ info.response }"
.catch (err) ->
  console.log err
