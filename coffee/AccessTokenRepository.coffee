class AccessTokenRepository

  constructor: (props = {}) ->
    @collection = props.collection
    @refreshTokenIndex = props.refreshTokenIndex
    @setDefaults()

  setDefaults: ->
    @collection ?= {}
    @refreshTokenIndex ?= {}

  store: (accessToken, callback) ->
    @collection[accessToken.value] = accessToken
    @refreshTokenIndex[accessToken.refreshToken] = accessToken.value
    return callback null, accessToken

  find: (value, callback) ->
    accessToken = @collection[value]
    return callback null, accessToken

  findByRefreshToken: (query, callback) ->
    value = @refreshTokenIndex[query.refreshToken]
    return callback null, null unless value?
    accessToken = @collection[value]
    return callback null, accessToken

module.exports = AccessTokenRepository
