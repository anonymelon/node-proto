'use strict';

var crypto = require('crypto');
var program = require('commander');
var request = require('./request').request;

function createSign(args){
    var apiKeyValue = '7ecfc6e6c4a8ab28fcf3a41d241c3888';
    var signlist = [];
    for(var arg in args){
        signlist.push(arg + args[arg]);
    }

    signlist.sort();
    var md5 = crypto.createHash('md5');
    var sign = md5.update(apiKeyValue + signlist.join('') + apiKeyValue);
    sign = md5.digest('hex').toUpperCase();
    args.sign = sign;
}

function getGeofences(){
    var args = {
        apiVersion: program.apiVersion,
        platform: program.platform,
        pushPlatform: program.pushPlatform,
        apiKey: program.apiKey,
        appKey: program.appKey,
        token: program.token,
        udid: program.udid
    };
    createSign(args);
    return request(args, program.hostname, '/api/push/geofences', 'GET');
}

function pushUserfence(fence){
    var args = {
        apiVersion: program.apiVersion,
        platform: program.platform,
        pushPlatform: program.pushPlatform,
        apiKey: program.apiKey,
        appKey: program.appKey,
        token: program.token,
        udid: program.udid,
        fenceId: fence.id,
        fenceIdStr: fence.id_str,
        triggerTime: '2014-05-26 04:03:27',
        triggerType: 'in',
        lon: '121.156',
        lat: '31.156'
    };

    createSign(args);

    return request(args, program.hostname, '/api/push/userfence', 'POST', 'form');
}

program
    .usage('[options] [value ...]')
    .option('-u, --userName <string>', 'User name')
    .option('-K, --appKey <string>', 'App key')
    .option('-h, --hostname <string>', 'Default is http://mk.tuisongbao.com:80')
    .option('-i, --interval <n>', 'Push userFence interval(seconds), if not set, only send once', parseFloat)
    .option('-p, --platform <string>', 'android or ios')
    .option('-t, --token <string>', 'Device token')
    .option('-d, --udid <string>', 'Device udid')
    .option('-f, --fenceName <string>', 'Fence name');

program.parse(process.argv);

program.apiKey = 'andriodsdk1.0';
program.apiVersion = 1.1;

if(!program.hostname)
    program.hostname = 'http://mk.tuisongbao.com:80';

if(program.platform == 'android'){
    program.pushPlatform = 'a2dm';
}else{
    program.pushPlatform = 'apns';
}

getGeofences()
.then(function(fenceList){
    fenceList = fenceList.fences;
    var fence = fenceList[i];
    for (var i in fenceList){
        if(fenceList[i].name == program.fenceName){
            fence = fenceList[i];
            break;
        }
    }

    if (fence === null){
        console.log('Fence is not exist');
        process.exit(0);
    }

    pushUserfence(fence)
    .then(function(res){
        console.log(res);
    });

    if (program.interval) {
        setInterval(function() {
            pushUserfence(fence)
            .then(function(res){
                console.log(res);
            });
        }, program.interval * 1000);
    }
});
