'use strict'

var SocketCluster = require('socketcluster').SocketCluster;
var socketCluster = new SocketCluster({
    port: 3000,
    balancers: 1,
    workers: 3,
    stores: 3,
    appName: 'testApp',
    workerController: 'worker.js',
    // balancerController: 'firewall.js', // Optional
    // storeController: 'store.js', // Optional
    // useSmartBalancing: true, // Optional - If true, load balancing will be based on session id instead of IP address. Defaults to true.
    rebootWorkerOnCrash: false // Optional, makes debugging easier - Defaults to true (should be true in production),
});
