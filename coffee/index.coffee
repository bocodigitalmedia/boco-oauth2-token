exports.AccessTokenService = require './AccessTokenService'
exports.AccessToken = require './AccessToken'

exports.createService = (config) ->
  new exports.AccessTokenService config
