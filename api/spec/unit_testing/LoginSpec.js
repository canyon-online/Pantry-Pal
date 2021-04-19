describe("Login", function() {
    const Login = require('../../routes/login');
    const Response = require('../test_models/res');

    // Test login user and response object
    var res;
    var loginVals;

    // Create a new Express response object for every login test
    beforeEach(function() {
        res = new Response();
        loginVals = {};
    });

    // Testing the verifyLocal function
    describe("verification", function() {
        it("should allow properly formatted data to be passed to bcrypt", function() {
            // Properly formatted data
            loginVals.body = { email: "email@email.com", password: "password" };

            // Ensure that the data is passed properly
            const testCall = Login.verifyLocal(loginVals.body, res);
    
            // We expect the return value of verifyLocal to be true if there was no error
            // We also expect the response object to have certain properties after success
            expect(testCall).toEqual(true);
            expect(res.statusCode).toEqual(200);
            expect(res.body).toEqual(undefined)
        });

        it("should disallow improperly formatted data to be passed to bcrypt", function() {
            // Improperly formatted data
            loginVals.body = { email: 12345, password: "password" };

            // Ensure that the data is passed properly
            const testCall = Login.verifyLocal(loginVals.body, res);

            // We expect the return value of verifyLocal to be true if there was no error
            // We also expect the response object to have certain properties after success
            expect(testCall).toEqual(false);
            expect(res.statusCode).not.toEqual(200);
            expect(res.body).not.toEqual(undefined)
        });

        it("should disallow missing data from being passed to bcrypt", function() {
            // Improperly formatted data
            loginVals.body = undefined;

            const testCall = Login.verifyLocal(loginVals.body, res);

            // We expect the return value of verifyLocal to be false if there was an error
            // We also expect the response object to have certain properties after an error
            expect(testCall).toEqual(false);
            expect(res.statusCode).not.toEqual(200);
            expect(res.body).not.toEqual(undefined)
        });
    });

    // Testing the loginLocal function
    // Slightly less of a "unit test"
    describe("locally", function() {

    });
});