Async = require 'async'
AccessTokenRepository = require './AccessTokenRepository'
AccessToken = require './AccessToken'
MS = require('boco-time').MilliSeconds

class AccessTokenService
  @DEFAULT_ACCESS_TOKEN_EXPIRY: MS.hours(4)
  @DEFAULT_REFRESH_TOKEN_EXPIRY: MS.weeks(2)

  constructor: (props = {}) ->
    @accessTokenRepository = props.accessTokenRepository
    @accessTokenExpiry = props.accessTokenExpiry
    @accessTokenType = props.accessTokenType
    @setDefaults()

  setDefaults: ->
    @accessTokenType ?= "bearer"
    @accessTokenExpiry ?= @constructor.DEFAULT_ACCESS_TOKEN_EXPIRY
    @refreshTokenExpiry ?= @constructor.DEFAULT_REFRESH_TOKEN_EXPIRY
    @accessTokenRepository ?= new AccessTokenRepository()

  constructAccessToken: (props = {}) ->
    token = new AccessToken props

  generateAccessTokenString: (bytes = 16, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  generateRefreshTokenString: (bytes = 16, encoding = 'base64') ->
    require('crypto').randomBytes(bytes).toString(encoding)

  grantAccessToken: (params = {}, callback) ->

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
    _clientId = params.clientId
    _refreshToken = params.refreshToken
    _service = this
    _accessTokenRepository = @accessTokenRepository
    _oldAccessToken = null
    _newAccessToken = null

    findAccessToken = (done) ->
      query = refreshToken: _refreshToken
      _accessTokenRepository.findByRefreshToken query, (error, accessToken) ->
        return done error if error?
        _oldAccessToken = accessToken
        done()

    assertAccessTokenFound = (done) ->
      error = Error "No token found with this refresh token"
      return done(error) unless _oldAccessToken?
      done()

    assertAccessTokenBelongsToClient = (done) ->
      error = Error "Access token does not belong to this client"
      return done(error) unless _oldAccessToken.clientId is _clientId
      done()

    constructNewAccessToken = (done) ->
      newAccessToken = _service.constructAccessToken
        type: _oldAccessToken.type
        clientId: _oldAccessToken.clientId
        userId: _oldAccessToken.userId
        expiresIn: _oldAccessToken.expiresIn

      newAccessToken.value = _service.generateAccessTokenString()
      newAccessToken.refreshToken = _service.generateRefreshTokenString()
      _newAccessToken = newAccessToken
      return done()

    storeNewAccessToken = (done) ->
      _accessTokenRepository.store _newAccessToken, (error, accessToken) ->
        return done error if error?
        _newAccessToken = accessToken
        done()

    markOldAccessTokenAsRefreshed = (done) ->
      _oldAccessToken.hasBeenRefreshed = true
      _accessTokenRepository.store _oldAccessToken, (error) ->
        return done error if error?
        done()

    steps = [
      findAccessToken
      assertAccessTokenFound
      assertAccessTokenBelongsToClient
      constructNewAccessToken
      storeNewAccessToken
      markOldAccessTokenAsRefreshed
    ]

    Async.series steps, (error) ->
      return callback error if error?
      return callback null, _newAccessToken

module.exports = AccessTokenService
