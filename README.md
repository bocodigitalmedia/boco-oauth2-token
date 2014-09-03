# boco-oauth2-token

OAuth2 Token Service.

    BocoOAuth2Token = require 'boco-oauth2-token'
    assert = require 'assert'

The following code is used to help run asynchronous steps within this readme.

    Async = require 'async'
    steps = []
    step = (name, fn) -> steps.push name: name, fn: fn

    process.nextTick ->

      runStep = (step, done) ->
        console.log "* #{step.name}"
        step.fn.call null, done

      Async.eachSeries steps, runStep, (error) ->
        return process.exit(0) unless error?
        console.error error
        process.exit 1

## configuration

    config = {}

### config.accessTokenExpiry
The time in ms for a token to expire.

    config.accessTokenExpiry = 60000

### config.accessTokenType
The type of token to dispense.

    config.accessTokenType = "bearer"

### config.accessTokenRepository

The access token repository to use for this service.

    config.accessTokenRepository =
      new BocoOAuth2Token.AccessTokenRepository.Memory()

## creating the service

    tokenService = BocoOAuth2Token.createService config

## grant a token

Grant a token for a user to a client by passing in the `userId` and  `clientId` to the `grantAccessToken` method.

    step "grant a token", (done) ->

      params =
        clientId: 'fd21166c-7da2-4316-b469-21b6f1545b90'
        userId: '80bae2aa-f835-449a-9f02-27f20bf64076'

      tokenService.generateAccessTokenString = -> "access-token-1"
      tokenService.generateRefreshTokenString = -> "refresh-token-1"

      tokenService.grantAccessToken params, (error, accessToken) ->
        return done error if error?
        delete tokenService.generateAccessTokenString
        delete tokenService.generateRefreshTokenString

        assert.equal 'fd21166c-7da2-4316-b469-21b6f1545b90', accessToken.clientId
        assert.equal '80bae2aa-f835-449a-9f02-27f20bf64076', accessToken.userId
        assert.equal "access-token-1", accessToken.value
        assert.equal "refresh-token-1", accessToken.refreshToken
        assert.equal 60000, accessToken.expiresIn
        assert.equal "bearer", accessToken.type
        done()

## refresh a token

Refresh a token by passing in the `clientId` and the `refreshToken` to the `refreshAccessToken` method.

    step "refresh a token", (done) ->

      params =
        clientId: 'fd21166c-7da2-4316-b469-21b6f1545b90'
        refreshToken: "refresh-token-1"

      tokenService.refreshAccessToken params, (error, accessToken) ->
        return done error if error?

        assert.equal 'fd21166c-7da2-4316-b469-21b6f1545b90', accessToken.clientId
        assert.equal '80bae2aa-f835-449a-9f02-27f20bf64076', accessToken.userId
        assert.equal 60000, accessToken.expiresIn
        assert.equal "bearer", accessToken.type
        done()


<br><br><br><br><br>
---
_The following code runs the asynchronous steps defined in this document__
