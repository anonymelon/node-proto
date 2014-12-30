var express = require('express');
var router = express.Router();
var crypto = require('crypto');

var secret = 'fdedcb39ba3e761a94958fbe';

var mockUserData = {
  userId: 'OUHJGkjhbiuNGHb',
  info: 'Mock User Data'
}

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.post('/engine_auth', function(req, res) {
  signatureData =[req.body.socketId, req.body.channelName];
  if(req.body.userData) {
    signatureData.push(JSON.parse(req.body.userData));
  }

  var signature = sign(signatureData.join(":"));

  res.set("Access-Control-Allow-Origin", "*");

  var returnData = { signature: signature }
  if(!req.body.channelName.indexOf('presence-')){
    returnData.channelData = mockUserData
  }
  // res.send(401)
  res.send(returnData);
});

router.options('/engine_auth', function(req, res) {
  signatureData =[req.body.socketId, req.body.channelName];
  if(req.body.userData) {
    signatureData.push(JSON.parse(req.body.userData));
  }

  var ret = sign(signatureData.join(":"));

  res.set("Access-Control-Allow-Origin", "*");
  res.set("Access-Control-Allow-Methods", "GET,POST,PUT,DELETE,OPTIONS");
  res.set("Access-Control-Allow-Headers", "Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

  res.send({ signature: ret });
});


module.exports = router;


function sign(str) {
  return crypto.createHmac('sha256', secret).update(str).digest('hex');
};


function decryptSignature (signature, secret) {
  return crypto.createDecipher('sha256', secret).update(signature).final('uti8');
}
