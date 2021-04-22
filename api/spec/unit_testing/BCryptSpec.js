describe("BCryptUtil", function() {
    const Bcrypt = require('../../routes/lib/bcryptUtil');

    const PassVals = {
        password: "password",
        hashword: ""
        //callback?
    }

    it("should encrypt a given password", function() {
        // Encrypt the given password
        //Bcrypt.encryptPassword(PassVals.password, callback);

        // We expect the callback function to return an error or the hashed password
    });

    //maybe we should have two specs for this, one with the properly
    //hashed password and another with the wrong one?
    it("should compare a plain password and an encrypted password", function() {
        // Compare the password to its hashword
        //Bcrypt.comparePassword(PassVals.password, PassVals.hashword, callback);
    });
});