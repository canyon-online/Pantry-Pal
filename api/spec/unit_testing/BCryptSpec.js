describe("BCryptUtil", function() {
    const Bcrypt = require('../../routes/lib/bcryptUtil');

    // Create password constants to test encrypt and compare functions
    const password = "password";
    const falsePassword;

    // Create hashedPassword var to test encrypt and compare functions
    var hashedPassword;

    it("should encrypt a given password", function() {
        // Encrypt the given password
        hashedPassword = Bcrypt.encryptPassword(password, function(err, hashedPassword) {
            expect(err).notToEqual(null);
            expect(hashedPassword.notToEqual(null));
        });
    });

    // Test a password that matches the hashword
    it("should positively match password", function() {
        // Compare the password to the hashedPassword, we expect for the match to be true
        Bcrypt.comparePassword(password, hashedPassword, function(err, doPasswordsMatch) {
            expect(doPasswordsMatch).toEqual(true);
        });
    });

    // Test a password that doesn't match the hashword
    it("should negatively match password", function() {
        // Compare the false password to the hashedPassword, we expect for the match to be false
        Bcrypt.comparePassword(falsePassword, hashedPassword, function(err, doPasswordsMatch) {
            expect(doPasswordsMatch).toEqual(false);
        });
    });
});
