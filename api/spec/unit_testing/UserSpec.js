describe("User", function() {
    const User = require('../../routes/users');

    // Test response and user objects
    var res, user;

    // Create a new response and user objects for testing
    beforeEach(function() {
        res = new Response();
        user = new userSchema({ _id: "userId", display: "name", verified: "verified", email: "gmail@gmail.com"});
    });

    it("should properly handle errors for /users endpoints", function() {
        // Check to see if there were errors
        //User.handleUserQueryErrors(err, user, res, cb);

        // We expect there to be a callback if there were no errors
    });
});