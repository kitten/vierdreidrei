var vdd = require('./index.js');

vdd.emitter.on('data', function(chunk) {
  console.log('Data: ' + chunk);
});

vdd.emitter.on('ready', function(chunk) {
  vdd.send(123456, function(err) {
  });
});
