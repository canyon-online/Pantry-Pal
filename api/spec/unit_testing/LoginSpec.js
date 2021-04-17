describe("Login", function() {
    var Login = require('../../routes/login');

    // Test res object
    const res;

    // Constant
    const LoginVals = {
        body: "body",
        res: res
    }

    // Create a token
    var token;

    it("should ensure that passed data is formatted properly", function() {
        // Ensure that the data is passed properly
        token = Login.verifyLocal(LoginVals.body, LoginVals.res);

        // We expect the return value of verifyLocal to be true if there was no error
        expect(token).toBeVerified(LoginVals.res);
    });
});