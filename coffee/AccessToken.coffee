class AccessToken

  constructor: (props = {}) ->
    @userId = props.userId
    @clientId = props.clientId
    @type = props.type
    @value = props.value
    @expiresAt = props.expiresAt
    @refreshToken = props.refreshToken

  expireIn: (ms = 0) ->
    currentTime = new Date().getTime()
    expiresAt = currentTime + ms
    @expiresAt = new Date expiresAt

  isExpired: (currentDate) ->
    return false unless @expiresAt?
    currentDate ?= new Date()
    expirationDate = new Date @expiresAt
    return currentDate > expirationDate

module.exports = AccessToken
