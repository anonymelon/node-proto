'use strict';
var http = require('http');
var https = require('https');
var url = require('url');
var querystring = require('querystring');

var Promise = require('bluebird');

exports.request = function (args, host, path, method, type){
    return new Promise(function (resolve, reject){
        var argsToSend = {};
        var hostObject = url.parse(host);
        var request = http.request;

        if(hostObject.protocol === 'https:'){
            request = https.request;
        }

        var options = {
            hostname: hostObject.hostname,
            port: hostObject.port,
            method: method,
            path: path
        };

        if(method === 'GET'){
            options.path = url.format({
                pathname: path,
                search: querystring.stringify(args)
            });
            console.log(options.path);
        }
        else{
            if(type == 'form'){
                argsToSend = querystring.stringify(args);
                console.log(argsToSend);
                options.headers = {
                    'Content-Type': 'application/x-www-form-urlencoded'
                };
            }else{
                argsToSend = JSON.stringify(args);
                console.log(argsToSend);
                options.headers = {
                    'Content-Length': argsToSend.length,
                    'Content-Type': 'application/json'
                };
            }
        }

        var req = request(options, function(res){
            res.setEncoding('utf-8');

            var result = '';
            res.on('data', function(data){
                result += data;
            });

            res.on('end', function(){
                console.log(result);
                result = JSON.parse(result);
                if (result.ack && result.ack.toString() !== '0'){
                    console.error(result);
                    reject(result);
                    return;
                }

                resolve(result);
            });

        });

        if(method === 'POST'){
            req.write(argsToSend);
        }
        req.end();
    });
};
