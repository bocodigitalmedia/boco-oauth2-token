exports.AccessTokenService = require './AccessTokenService'
exports.AccessToken = require './AccessToken'
exports.AccessTokenRepository = require './AccessTokenRepository'

exports.createService = (config) ->
  new exports.AccessTokenService config
