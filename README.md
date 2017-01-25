# compulsory
### Require, really.

[![Greenkeeper badge](https://badges.greenkeeper.io/zeekay/compulsory.svg)](https://greenkeeper.io/)

Require module, installing it if necessary.

## Install
```bash
npm install compulsory
```

## Usage
```javascript
var compulsory = require('compulsory');

// Require module or install if necessary
var coffee = compulsory('coffee-script');

// Silently install, create package.json if it's missing and stick it all in
// process.cwd()
var coffee = compulsory('coffee-script', {
    createPackageJson: true,
    into: process.cwd(),
    silent: true,
})
```
