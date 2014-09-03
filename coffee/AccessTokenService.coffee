AccessTokenRepository = require './AccessTokenRepository'
AccessToken = require './AccessToken'
TimeInMs = require './TimeInMs'

class AccessTokenService

  constructor: (props = {}) ->
    @accessTokenRepository = props.accessTokenRepository
    @accessTokenExpiry = props.accessTokenExpiry
    @accessTokenType = props.accessTokenType
    @setDefaults()

  setDefaults: ->
    @accessTokenType ?= "bearer"
    @accessTokenExpiry ?= 4 * TimeInMs.hour
    @refreshTokenExpiry ?= 2 * TimeInMs.week
    @accessTokenRepository ?= new AccessTokenRepository.Memory()

  constructAccessToken: (props = {}) ->
    token = new AccessToken props

  generateAccessTokenString: (bytes = 32, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  generateRefreshTokenString: (bytes = 32, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  grantAccessToken: (props = {}, callback) ->

    # Construct a new token
    accessToken = @constructAccessToken
      type: @accessTokenType
      clientId: props.clientId
      userId: props.userId
      expiresIn: @accessTokenExpiry

    accessToken.value = @generateAccessTokenString()
    accessToken.refreshToken = @generateRefreshTokenString()

    @accessTokenRepository.store accessToken, (error, accessToken) ->
      return callback error if error?
      return callback null, accessToken

module.exports = AccessTokenService
