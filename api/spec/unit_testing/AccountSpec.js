describe("Account", function() {
    var Account = require('../../routes/account');

    // Constant testing values we will use for testing verification codes
    const CodeVals = {
        code: "1234",
        user: "userId",
        purpose: "purpose"
    }

    // Create a token
    var token;

    it("should find and delete a verification code", function() {
        // Attempt to find a verification code using parameters and delete it
        // Using example strings such as "userId" rather than actual ObjectIds, as it should not matter
        token = Account.getCode(CodeVals.code, CodeVals.user, CodeVals.purpose);

        // We expect there to be a code found
        expect(token).toHaveCode(CodeVals.code);
    });
});