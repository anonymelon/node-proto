'use strict'

var should = require('chai').should();
var RealtimeEngine = require('../').RealtimeEngine;

var appId = 'ba55d7d9472260547a867e00'
var secret = 'bb039c0d83daf11390b373b3'

describe('Realtime Engine Server SDK', function() {
  before(function() {
    var engine = new RealtimeEngine(appId, secret);
  });
});
