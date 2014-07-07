'use strict';

var http = require('http');
var Promise = require('bluebird');


var config = require('./config').config;


var request = function(options) {
  return new Promise(function(resolve, reject) {
    var req = http.request(options, function(res) {
      var result = '';
      res.setEncoding('utf-8');
      res.on('data', function(data) {
        result += data.toString();
      })

      res.on('end', function() {
        var reg = new RegExp('http://*.*.html', 'ig');
        var urls = result.match(reg);
        resolve(urls);
      })
    });
    req.on('error', function(e) {
      reject(e);
    })
    req.end();
  })
}

var get = function(url) {
  return new Promise(function(resolve, reject) {
    var req = http.get(url, function(res) {
      var result = '';
      res.setEncoding('utf-8');
      res.on('data', function(data) {
        result += data;
      })

      res.on('end', function() {
        resolve(result);
      })
    });

    req.on('error', function(e) {
      reject(e);
    })
  })
}

module.exports.request = request;
module.exports.get = get;