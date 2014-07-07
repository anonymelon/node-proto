mongoose = require 'mongoose'
User = require 'user'


mongoose.connect 'localhost', 'mongoose'

# foo = new User(
#     name: 'coffee'
# )

foo.save (err) -> 
	return console.error(err) if err 
  console.log('saved')

result = User.findByName('bar')
console.log(User.findByName())


