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

  grantAccessToken: (params = {}, callback) ->

    # Construct a new token
    accessToken = @constructAccessToken
      type: @accessTokenType
      clientId: params.clientId
      userId: params.userId
      expiresIn: @accessTokenExpiry

    accessToken.value = @generateAccessTokenString()
    accessToken.refreshToken = @generateRefreshTokenString()

    @accessTokenRepository.store accessToken, (error, accessToken) ->
      return callback error if error?
      return callback null, accessToken

  refreshAccessToken: (params = {}, callback) ->
    clientId = params.clientId
    refreshToken = params.refreshToken
    query = refreshToken: refreshToken
    service = this
    accessTokenRepository = @accessTokenRepository

    accessTokenRepository.findByRefreshToken query, (error, accessToken) ->
      return callback error if error?

      unless accessToken?
        return callback Error("No token found with this refresh token")

      unless accessToken.clientId is clientId
        return callback Error("Access token belongs to another client")

      newAccessToken = service.constructAccessToken
        type: accessToken.type
        clientId: accessToken.clientId
        userId: accessToken.userId
        expiresIn: accessToken.expiresIn

      newAccessToken.value = service.generateAccessTokenString()
      newAccessToken.refreshToken = service.generateRefreshTokenString()

      accessTokenRepository.store newAccessToken, (error, newAccessToken) ->
        return callback error if error?
        return callback null, newAccessToken


module.exports = AccessTokenService
