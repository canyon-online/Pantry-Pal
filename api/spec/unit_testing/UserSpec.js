const { handleUserQueryErrors } = require('../../routes/users');

describe("User", function() {
    const User = require('../../routes/users');
    const userSchema = require('../../models/user');

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
        handleUserQueryErrors(yesError, user, res, function(){});

        // We expect the res status to be 422
        expect(res.status).toEqual(422);
    });

    it("should not catch an error", function() {
        // Call function without an error
        handleUserQueryErrors(err, user, res, function(){});

        // We expect the res status to be 200
        expect(res.status).toEqual(200);
    });

    it("should catch no user", function() {
        // Call function without a user
        handleUserQueryErrors(err, null, res, function(){});

        // We expect the res status to be 404
        expect(res.status).toEqual(404);
    });

    it("should catch a user", function() {
        // Call function with a user
        handleUserQueryErrors(err, user, res, function(){});

        // We expect the res status to be 200
        expect(res.status).toEqual(200);
    });
});