'use strict'
const merge = require('webpack-merge')
const prodEnv = require('./prod.env')

module.exports = merge(prodEnv, {
  NODE_ENV: '"development"',
  GAUTH_APP_CLIENT_ID: '"496834929234-3m4qiabe2js95a50sil960d0oct2b3er.apps.googleusercontent.com"',
  GAUTH_APP_SCOPE: '"profile email"'
})
