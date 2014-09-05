var net = require('net');
var crypto = require('crypto');
var querystring = require('querystring');

var HOST = '127.0.0.1';
var PORT = 3007;
var clients = 10
var keySecretPair = {
  key: 'androidsdk1.0',
  secret: '7ecfc6e6c4a8ab28fcf3a41d241c3888'
};


var apiKey = keySecretPair.key;
var secret = keySecretPair.secret;
var CRLF = '\r\n';

function createSign(params, secret) {
  var queryStr = Object.keys(params).sort().reduce(function(memo, key) {
    return memo + key + params[key];
  }, secret);
  queryStr += secret;

  return crypto.createHash('md5').update(queryStr, 'utf-8').digest('hex').toUpperCase();
}

function genRequestData(token) {
  var parms = {
    token: token,
    apiKey: apiKey
  };
  parms.sign = createSign(parms, secret);
  var parmsStr = querystring.stringify(parms);

  var getData = 'GET /?' + parmsStr + ' HTTP/1.1' + CRLF;
  //getData += 'HOST: ' + host + ':' + port + CRLF;
  getData += CRLF;

  return getData;
}

var token = '555c4525ccd80f2a49330c7d'

for (var i = 0; i <= clients; i++) {
  var client = new net.Socket();
  client.connect(PORT, HOST, function() {
    console.log('Connect to ' + HOST + 'port ' + PORT);
    var requestData = genRequestData(token);
    client.write(requestData);
  });

  client.on('data', function(data) {
    console.log('Got data: ' + data);
  });

  client.on('close', function() {
    console.log('Connection closed');
  });
};
