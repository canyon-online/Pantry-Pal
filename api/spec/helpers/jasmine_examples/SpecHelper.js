beforeEach(function () {
  jasmine.addMatchers({
    toHaveAlgorithm: function() {
      return {
        compare: function(actual, expected) {
          var token = actual;

          // JWTs are three parts split with '.'
          // The first part contain the algorithm used, so extract it from the whole token
          token = token.split('.')[0];

          // This is a base64 encoded JSON object, so have to convert from base64 and JSONify it
          token = Buffer.from(token, 'base64').toString();
          token = JSON.parse(token);

          // Now we can read the algorithm used for the JWT and the typ attribute
          // More information about structure can be found at https://jwt.io/

          return {
            pass: token.alg == expected
          }
        }
      }
    },

    toHavePayload: function() {
      return {
        compare: function(actual, expected) {
          var token = actual;

          // Same process as above, just condensed into a one liner for the second part of the token
          token = JSON.parse(Buffer.from(token.split('.')[1], 'base64').toString());

          // Slightly more complicated passing case
          var pass = true;

          // If any payload data is mismatched, then we have not met expectations
          for (var key in expected) {
            if (token[key] != expected[key]) {
              pass = false;
            }
          }

          return {
            pass: pass
          }
        }
      }
    }
  });
});
