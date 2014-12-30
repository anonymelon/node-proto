var crypto = require('crypto');

var secret = 'fdedcb39ba3e761a94958fbe';


function sign(str) {
  return crypto.createHmac('sha256', secret).update(str).digest('hex');
};


function decryptSignature (signature, secret) {
  return crypto.createDecipher('sha256', secret).update(signature).final('uti8');
}


var singRet = sign('awefawefawef')

console.log(singRet, '@@@@@@@@@@@@@');


var decryRet = decryptSignature(singRet, secret)

console.log(decryRet, '---------------');
