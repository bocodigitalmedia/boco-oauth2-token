// Generated by CoffeeScript 1.6.3
(function() {
  var AccessToken, AccessTokenService;

  AccessToken = require('./AccessToken');

  AccessTokenService = (function() {
    function AccessTokenService(props) {
      if (props == null) {
        props = {};
      }
      this.accessTokenExpiry = props.accessTokenExpiry;
      this.accessTokenType = props.accessTokenType;
      this.setDefaults();
    }

    AccessTokenService.prototype.setDefaults = function() {
      if (this.accessTokenType == null) {
        this.accessTokenType = "bearer";
      }
      return this.accessTokenExpiry != null ? this.accessTokenExpiry : this.accessTokenExpiry = 1000 * 60 * 60;
    };

    AccessTokenService.prototype.constructAccessToken = function(props) {
      var token;
      if (props == null) {
        props = {};
      }
      return token = new AccessToken(props);
    };

    AccessTokenService.prototype.generateAccessTokenString = function(bytes, encoding) {
      if (bytes == null) {
        bytes = 32;
      }
      if (encoding == null) {
        encoding = 'base64';
      }
      return require('crypto').randomBytes(bytes).toString(encoding);
    };

    AccessTokenService.prototype.generateRefreshTokenString = function(bytes, encoding) {
      if (bytes == null) {
        bytes = 32;
      }
      if (encoding == null) {
        encoding = 'base64';
      }
      return require('crypto').randomBytes(bytes).toString(encoding);
    };

    AccessTokenService.prototype.grantAccessToken = function(props, callback) {
      var accessToken;
      if (props == null) {
        props = {};
      }
      accessToken = this.constructAccessToken({
        type: this.accessTokenType,
        clientId: props.clientId,
        userId: props.userId
      });
      accessToken.expireIn(this.accessTokenExpiry);
      accessToken.value = this.generateAccessTokenString();
      accessToken.refreshToken = this.generateRefreshTokenString();
      return callback(null, accessToken);
    };

    return AccessTokenService;

  })();

  module.exports = AccessTokenService;

}).call(this);

/*
//@ sourceMappingURL=AccessTokenService.map
*/