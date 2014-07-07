'use strict'

fs = require 'fs'

mongoose = require 'mongoose'
Location = require 'location'

mongoose.connect 'localhost', 'mongooseTest'

stream = fs.createReadStream './locationCode.csv', {encoding: 'utf8'}

console.log  stream

function read() {
  var buf;
  while (buf = stream.read()) {
    console.log('Read from the file:', buf);
  }
}

stream.on('readable', read);

stream.once('end', function() {
  console.log('stream ended');
});