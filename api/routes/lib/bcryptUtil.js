// Import bcrypt library for use in hashing passwords
const bcrypt = require('bcrypt');

// Given a password, encrypt it with a salt
// Will execute the callback function with error reporting
function encryptPassword(password, callback) {
    bcrypt.hash(password, 10, function(err, hash) {
        if (err)
            return callback(err);

        return callback(null, hash);
    });
}

// Given a plain password and an encrypted password, compare them
// If an error occurs, will return -1, otherwise return boolean
// Will execute the callback function with error reporting
function comparePassword(password, user, callback, res) {
    hashword = user.password;

    return bcrypt.compare(password, hashword, function(err, isPasswordMatch) {
        if (err == null) {
            if (isPasswordMatch) 
                return callback(null, user, res);
        }

        return callback("Did not match", null, res);
    });
}

// Export the async functions for this library
exports.encryptPassword = encryptPassword;
exports.comparePassword = comparePassword;