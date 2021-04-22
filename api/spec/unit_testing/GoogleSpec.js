describe("GoogleOAuthorization", function() {
    const Google = require('../../routes/lib/googleOAuth');

    // Test response object
    var res;

    // Create a new Express response object for every login test
    beforeEach(function() {
        res = new Response();
    });

    it("should return a ticket object that contains a payload", function() {
        //Google.getTicket(token);

        // We expect the ticket to have the same token as the one we gave it?
    });

    it("should verify token authenticity", function() {
        //Google.verifyGoogle(body, res);
    });

    it("should attempt to add a user to the database", function() {
        //Google.registerGoogle(res, ticket);
    });

    it("should attempt to log in a user", function() {
        //Google.loginGoogle(res, ticket);
    });
});
