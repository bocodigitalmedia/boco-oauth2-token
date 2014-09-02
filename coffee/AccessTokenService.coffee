AccessToken = require './AccessToken'

class AccessTokenService

  constructor: (props = {}) ->
    @accessTokenExpiry = props.accessTokenExpiry
    @accessTokenType = props.accessTokenType
    @setDefaults()

  setDefaults: ->
    @accessTokenType ?= "bearer"
    @accessTokenExpiry ?= 1000 * 60 * 60

  constructAccessToken: (props = {}) ->
    token = new AccessToken props

  generateAccessTokenString: (bytes = 32, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  generateRefreshTokenString: (bytes = 32, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  grantAccessToken: (props = {}, callback) ->
    accessToken = @constructAccessToken
      type: @accessTokenType
      clientId: props.clientId
      userId: props.userId

    accessToken.expireIn @accessTokenExpiry
    accessToken.value = @generateAccessTokenString()
    accessToken.refreshToken = @generateRefreshTokenString()

    callback null, accessToken

module.exports = AccessTokenService
