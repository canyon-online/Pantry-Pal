describe("BCryptUtil", function() {
    const Bcrypt = require('../../routes/lib/bcryptUtil');

    // Create password constants to test encrypt and compare functions
    const password = "password";
    const falsePassword = "passyword";

    // Create hashword var to test encrypt and compare functions
    var hashword;

    // Due to the asynchronous nature of these functions, testing is a bit finnicky and hard to write
    it("should encrypt a given password", function(done) {
        // Encrypt the given password
        Bcrypt.encryptPassword(password, function(err, hashedPassword) {
            expect(err).toBeNull();
            expect(hashedPassword).toBeDefined();
        
            hashword = hashedPassword;

            done();
        });
    });

    // Test a password that matches the hashword
    // We wrap the contents of this in a timeout to help ensure that the promise above is fulfilled
    // This is a really poor way of handling this but I'm unfamiliar with how to deal with asynchronicity
    it("should positively match passwords", function(done) {
        // Compare the password to the hashedPassword, we expect for the match to be true
        Bcrypt.comparePassword(password, hashword, function(err, doPasswordsMatch) {
            expect(err).toBeNull();
            expect(doPasswordsMatch).toEqual(true);

            done();
        });
    });

    // Test a password that doesn't match the hashword
    // We don't have to wrap this in a timeout because the synchronous nature of test case execution
    it("should fail to match incorrect passwords", function(done) {
        // Compare the false password to the hashedPassword, we expect for the match to be false
        Bcrypt.comparePassword(falsePassword, hashword, function(err, doPasswordsMatch) {
            expect(doPasswordsMatch).toEqual(false);

            done();
        });
    });
});
