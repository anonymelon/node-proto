var fs = require('fs');
fs.readFile('./locationCode.csv', function(err, data) {
    if(err) throw err;
    var array = data.toString().split("\n");
    for(i in array) {
        console.log(array[i].split(','));
    }
});