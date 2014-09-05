var redisConfig = {
  redis: {
    host: 'localhost',
    port: 6379,
    db: 0
  }
}
var kue = require('kue'),
  jobs = kue.createQueue(redisConfig),
  Job = kue.Job;

// var job = jobs.create('email', {
//     title: 'welcome email for tj'
//   , to: 'tj@learnboost.com'
//   , template: 'welcome-email'
// }).save( function(err){
//     console.log(job);
//     if( !err ) console.log( job.id );
// });


jobs.types(function(err, types) {
  if (err) {
    console.log(err);
  }
  console.log(types, '===============');
})

jobs.state('job', function(err, state) {
  console.log(state, '--------------');
})

Job.rangeByState('complete', 0, 100, 'asc', function (err, jobs) {
    if (err) return res.send({ error: err.message });
    console.log(jobs, '================');
});
