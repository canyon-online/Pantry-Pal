beforeEach(function () {
  jasmine.addMatchers({
    toBePlaying: function () {
      return {
        compare: function (actual, expected) {
          var player = actual;

          return {
            pass: player.currentlyPlayingSong === expected && player.isPlaying
          }
        }
      };
    },

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
    },

    toHaveCode: function() {
      return {
        compare: function(actual, expected) {
          var token = actual;
          var pass = true;

          // If the verification code for the account is not the same, return false
          if (token != expected)
          {
            pass = false;
          }

          return {
            pass: pass
          }
        }
      }
    },

    toBeVerified: function() {
      return {
        compare: function(actual, expected) {
          var token = actual;
          var pass = true;

          // If the return value for verifyLocal is contradictory to the
          // response status, return false
          if (token == true && expected.status == 422)
          {
            pass = false;
          }

          return {
            pass: pass
          }
        }
      }
    },

    ValidCode: function() {
      return {
        compare: function(actual, expected) {
          var token = actual;
          var pass = true;

          // If the generated verification code is not valid, return false
          if (expected[0] != token.code.length || expected[1] != token.id || expected[2] != token.purpose)
          {
            pass = false;
          }

          return {
            pass: pass
          }
        }
      }
    }
  });

  // Configure mongoose to use the local database
  const mongoose = require('mongoose');
  const MONGO_HOST = process.env.DB_HOST || 'localhost';
  const MONGO_PORT = process.env.DB_PORT || 27017;
  const MONGO_DB = process.env.DB_NAME || 'my_local_db';
  const MONGO_URI = `mongodb://${MONGO_HOST}:${MONGO_PORT}/${MONGO_DB}`;

  mongoose.connect(MONGO_URI, { 
    useNewUrlParser: true,
    useFindAndModify: false,
    useUnifiedTopology: true,
    useCreateIndex: true
  });

});
