'use strict';
var util = require('util');
var crypto = require('crypto');

var Promise = require('bluebird');
var program = require('commander');
var log4js = require('log4js');
log4js.configure({
  appenders: [ {type: 'console'},
    {
        type: 'file',
        filename: './simplePush.log'
    }
  ],
  levels:{
        simplePush: 'info'
    }
});
var logger = log4js.getLogger('simplePush');


var request = require('./request').request;

function oauth(apiKey, apiSecret, nick){
    // Calculate sign.
    var numberFormat = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09'];
    for(var i = 10; i <= 59; i++)
        numberFormat.push(i);

    var time = new Date();
    var timeString = util.format('%s-%s-%s %s:%s:%s',
        time.getUTCFullYear(),
        numberFormat[time.getUTCMonth() + 1],
        numberFormat[time.getUTCDate()],
        numberFormat[time.getUTCHours()],
        numberFormat[time.getUTCMinutes()],
        numberFormat[time.getUTCSeconds()]);

    var signlist = ['api_key' + apiKey, 'nick' + nick, 'time' + timeString];
    signlist.sort();

    var md5 = crypto.createHash('md5');
    var sign = md5.update(apiSecret + signlist.join('') + apiSecret);
    sign = md5.digest('hex').toUpperCase();

    // Request access token. (www.tuisongbao.com/v1/rest/oauth)
    var args = {
        api_key: apiKey,
        nick: nick,
        sign: sign,
        time: timeString
    };

    return request(args, program.hostname, '/v1/rest/oauth', 'POST', 'json');
}

function getAppId(accessToken, uid, appName){
    // . (www.tuisongbao.com/v1/rest/app)
    var args = {
        access_token: accessToken,
        uid: uid
    };

    return request(args, program.hostname, '/v1/rest/app', 'GET')
    .then(function(result){
        var apps = result.apps;
        for(var i in apps){
            if (apps[i].name === appName){
                return apps[i].app_id;
            }
        }

        throw new Error(appName + ' does not existed');
    });
}

function simplePush(accessToken, appId, reject){
    var platform = 0;
    // . (www.tuisongbao.com/v1/rest/notifications/simple)
    var args = {
        access_token: accessToken,
        app_key: appId,
        content: program.content,
        extra: {
            AI: '%%AI%%',
            BI: '%%BI%%'
        },
        platform: platform
    };

    if(program.tokens){
        var tokens = [];
        for(var j = 0; j < program.tokens.length; j++){
            tokens.push({
                t: program.tokens[j],
                ud: {
                    // Get ramdom from 0 to 99
                    badge: Math.floor( Math.random() * 100 ),
                    AI: Math.floor( Math.random() * 100 ),
                    BI: Math.floor( Math.random() * 100 )
                }
            });
        }
        args.tokens = JSON.stringify(tokens);
    }

    request(args, program.hostname, '/v1/rest/notifications/simple', 'POST', 'json')
    .then(function(result){
        console.log(result);
        success++;
    })
    .catch(function(err){
        if (err.ack.toString() == 2 || err.ack.toString() == 3){
            reject(err);
        }else{
            logger.error(err);
            failure++;
        }
    });
}

function list(val) {
  return val.split(',');
}

program
    .usage('[options] [value ...]')
    .option('-k, --apiKey <string>', 'Api key')
    .option('-s, --apiSecret <string>', 'Api secret')
    .option('-u, --userName <string>', 'User name')
    .option('-n, --appName <string>', 'App name')
    .option('-h, --hostname <string>', 'Default is http://rest.mk.tuisongbao.com:80')
    .option('-i, --interval <n>', 'Send notification interval(seconds), if not set, only send once', parseFloat)
    .option('-t, --token <string>', 'If token is set, message will be send by token; otherwise will send to all')
    .option('-c, --count <n>', 'Send message to device specific times, token options is needed, default is 1', parseInt)
    .option('-T, --tokens <string>', 'Token list, split by ",". Can not use token and tokens at the same time', list)
    .option('-C, --content <string>', 'Custom message content, default content is Hello world');

program.parse(process.argv);

if(!program.hostname)
    program.hostname = 'http://api.dev.new.tuisongbao.com:3004';

if(!program.content)
    program.content = 'Hello world--' + new Date();

if(program.token){
    program.tokens = [];
    var count = program.count || 1;
    for(var i = 0; i < count; i++){
        program.tokens.push(program.token);
    }
}

var success = 0;
var failure = 0;
var appId = null;
var pushInterval = null;
function run(){
    oauth(program.apiKey, program.apiSecret, program.userName)
    .then(function(res){
        // console.log('Get access_token:', res.access_token);
        // if(!appId){
        //     appId = getAppId(res.access_token, res.uid, program.appName);
        // }
        appId = program.appName
        return [res.access_token, appId];
    })
    .spread(function(access_token, appId){
        // Send message
        if(program.interval){
            return new Promise(function(resolve, reject){
                pushInterval = setInterval(simplePush, program.interval * 1000, access_token, appId, reject);
            });
        }else{
            return simplePush(access_token, appId);
        }
    })
    .catch(function(err){
        console.log('run err', err);
        logger.debug(err);
        clearInterval(pushInterval);
        run();
    });
}

run();
if(program.interval)
    setTimeout(function() {
        clearInterval(pushInterval);
        run();
    }, 30 * 60 * 1000);

process.on('SIGINT', function () {
    logger.info('\nStop......',
        '\nTotally send:', success + failure,
        ', success:', success,
        ', failure:', failure,
        '\nSuccess rate:', success / (success + failure) * 100, '%\n');

    process.exit(0);
});

