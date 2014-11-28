var express = require('express');
var router = express.Router();

/* GET home page. */
router.get('/', function(req, res) {
  res.render('index', { title: 'Express' });
});

router.get('/chat', function(req, res) {
  res.render('chat', { title: 'Express' });
});

router.get('/reChat', function(req, res) {
  res.render('reChat', { title: 'Express' });
});

module.exports = router;
