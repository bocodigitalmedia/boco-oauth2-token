// Generated by CoffeeScript 1.6.3
(function() {
  var AccessTokenRepository;

  AccessTokenRepository = (function() {
    function AccessTokenRepository(props) {
      if (props == null) {
        props = {};
      }
      this.collection = props.collection;
      this.refreshTokenIndex = props.refreshTokenIndex;
      this.setDefaults();
    }

    AccessTokenRepository.prototype.setDefaults = function() {
      if (this.collection == null) {
        this.collection = {};
      }
      return this.refreshTokenIndex != null ? this.refreshTokenIndex : this.refreshTokenIndex = {};
    };

    AccessTokenRepository.prototype.store = function(accessToken, callback) {
      this.collection[accessToken.value] = accessToken;
      this.refreshTokenIndex[accessToken.refreshToken] = accessToken.value;
      return callback(null, accessToken);
    };

    AccessTokenRepository.prototype.find = function(value, callback) {
      var accessToken;
      accessToken = this.collection[value];
      return callback(null, accessToken);
    };

    AccessTokenRepository.prototype.findByRefreshToken = function(query, callback) {
      var accessToken, value;
      value = this.refreshTokenIndex[query.refreshToken];
      if (value == null) {
        return callback(null, null);
      }
      accessToken = this.collection[value];
      return callback(null, accessToken);
    };

    return AccessTokenRepository;

  })();

  module.exports = AccessTokenRepository;

}).call(this);

/*
//@ sourceMappingURL=AccessTokenRepository.map
*/