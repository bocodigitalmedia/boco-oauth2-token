class AccessToken

  constructor: (props = {}) ->
    @userId = props.userId
    @clientId = props.clientId
    @type = props.type
    @value = props.value
    @expiresIn = props.expiresIn
    @createdAt = props.createdAt
    @refreshToken = props.refreshToken
    @setDefaults()

  setDefaults: ->
    @createdAt ?= new Date()

  getCreationDate: ->
    return @createdAt if @createdAt instanceof Date
    return new Date @createdAt

  getExpirationDate: ->
    return undefined unless @expiresIn
    creationDate = @getCreationDate()
    expirationMs = creationDate.getTime() + @expiresIn
    return new Date expirationMs

  isExpired: (currentDate) ->
    currentDate ?= new Date()
    return currentDate > @getExpirationDate()

module.exports = AccessToken
