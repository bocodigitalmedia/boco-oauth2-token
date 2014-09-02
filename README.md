# boco-oauth2-token

OAuth2 Token Service.

    BocoOAuth2Token = require 'boco-oauth2-token'
    assert = require 'assert'

The following code is used to help run asynchronous steps within this readme.

    Async = require 'async'
    steps = []
    step = (name, fn) ->
      steps.push name: name, fn: fn

    runSteps = ->
      fns = steps.map (step) -> step.fn
      Async.series fns, (error) ->
        return process.exit(0) unless error?
        console.error error
        process.exit 1

    setImmediate runSteps

## configuration

    config = {}

### config.accessTokenExpiry
The time in ms for a token to expire.

    config.accessTokenExpiry = 1 * 60 * 60 * 1000

### config.accessTokenType
The type of token to dispense.

    config.accessTokenType = "bearer"

### config.accessTokenRepository

The access token repository to use for this service.

    class MemoryRepository
      constructor: ->
        @accessTokens = {}

      store: (id, accessToken, callback) ->
        @accessTokens[id] = accessToken
        callback null, accessToken

      find: (id, callback) ->
        callback null, @accessTokens[id]

    config.tokenRepository = new MemoryRepository()

## creating the service

    tokenService = BocoOAuth2Token.createService config

## grant a token

Grant a token for a user to a client by passing in the `userId` and  `clientId` to the `grantAccessToken` method.

    step "generate a token", (done) ->
      params =
        clientId: 'fd21166c-7da2-4316-b469-21b6f1545b90'
        userId: '80bae2aa-f835-449a-9f02-27f20bf64076'

      tokenService.generateAccessTokenString = -> "access-token-1"
      tokenService.generateRefreshTokenString = -> "refresh-token-1"

      tokenService.grantAccessToken params, (error, accessToken) ->
        return done error if error?

        assert.equal 'fd21166c-7da2-4316-b469-21b6f1545b90', accessToken.clientId
        assert.equal '80bae2aa-f835-449a-9f02-27f20bf64076', accessToken.userId
        assert.equal "access-token-1", accessToken.value
        assert.equal "refresh-token-1", accessToken.refreshToken
        assert.equal "bearer", accessToken.type
        done()


<br><br><br><br><br>
---
_The following code runs the asynchronous steps defined in this document__
