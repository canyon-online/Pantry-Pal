describe("User", function() {
    const Users = require('../../routes/users');
    const userSchema = require('../../models/user');
    const Response = require('../test_models/res');

    // Test response and user objects
    var res, user;

    const yesError = "yesError";
    const err = null;

    // Create a new response and user objects for testing
    beforeEach(function() {
        res = new Response();
        user = new userSchema({ _id: "userId", display: "name", verified: "verified", email: "gmail@gmail.com"});
    });

    it("should catch an error", function() {
        // Call function with an error
        Users.handleUserQueryErrors(yesError, user, res, function(){});

        // We expect the res status to be 422
        expect(res.statusCode).toEqual(422);
    });

    it("should not catch an error", function() {
        // Call function without an error
        Users.handleUserQueryErrors(err, user, res, function(){});

        // We expect the res status to be 200
        expect(res.statusCode).toEqual(200);
    });

    it("should catch no user", function() {
        // Call function without a user
        Users.handleUserQueryErrors(err, null, res, function(){});

        // We expect the res status to be 404
        expect(res.statusCode).toEqual(404);
    });

    it("should catch a user", function() {
        // Call function with a user
        Users.handleUserQueryErrors(err, user, res, function(){});

        // We expect the res status to be 200
        expect(res.statusCode).toEqual(200);
    });
});