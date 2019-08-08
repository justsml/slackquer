#!/usr/bin/env node
const getPort = require('get-port');

// node ./scripts/get-available-port.js

getPort()
  .then(port => process.stdout.write(`${port}`))
  .catch(console.error)
