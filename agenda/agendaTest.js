'use strict';

var Agenda = require('agenda');
var mongoose = require('mongoose');

mongoose.connect('localhost', 'agendaTest');
var User = require('./models/user');

var agenda = new Agenda({
  db: {
    address: 'localhost:27017/agendaTest'
  }
});

agenda.define('remove users', function(job, done) {
  console.log('got here');
  User.removeByName('Ahmed', function (err, count) {
    console.log(count);
    done();
  });
});

agenda.define('logTest', function(job, done) {
  console.log('got here');
  done();
});

agenda.on('start', function(job) {
  return console.log('Job started', job);
});

agenda.on('success', function(job) {
  return console.log('Job successed', job);
});

agenda.on('fail', function(err, job) {
  return console.log('Job failed', job, err);
});


agenda.every('*/1 * * * *', 'remove users');

agenda.start();