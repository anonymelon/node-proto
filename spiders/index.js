'use strict';


var requester = require('./requester');
var config = require('./config').config;
var Promise = require('bluebird');

var fs = Promise.promisifyAll(require('fs'));

// requester.request(config.options, function(res) {
//   var result = '';
//   res.on('data', function(data) {
//     result += data.toString();
//   })

//   res.on('end', function(argument) {
//     var reg = new RegExp('http://*.*.html', 'ig');
//     var urls = result.match(reg);
//     console.log(result.match(reg));
//   })
// });

requester
.request(config.options)
.map(function(url, i) {
  console.log(url);
  return requester.get(url)
  .then(function(data) {
    fs.writeFileAsync('./tmp/' + i + '.html', data, 'utf8')
    .then(function (result) {
      console.log(i);
    })
  })
  // .catch (function (err) {
  //   console.log('Catch error on get: '+err);
  // });
})
.catch (function(e) {
  console.log('Error message: ' + e);
})