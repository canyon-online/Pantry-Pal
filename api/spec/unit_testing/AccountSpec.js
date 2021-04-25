describe("Account", function() {
    const Account = require('../../routes/account');

    // Constant testing values we will use for testing verification codes
    const CodeVals = require('../helpers/db_setup/code.init').niceCode;

    it("should return nothing if the specified code does not exist", function() {
        // Returns a promise, so we have to fulfill the promise
        // Modifying the code parameter such that no code like this will exist
        var codePromise = Account.getCode(CodeVals.code + CodeVals.code, CodeVals.user, CodeVals.purpose);

        // After fulfilling the promise, check
        codePromise.then(function(code) {
            expect(code).toBeDefined();
        });
    });

    it("should find and delete a verification code", function() {
        // Attempt to find a verification code using parameters and delete it
        // Using example strings such as "userId" rather than actual ObjectIds, as it should not matter
        var codePromise = Account.getCode(CodeVals.code, CodeVals.user, CodeVals.purpose);

        codePromise.then(function(code) {
            // Expect a code to have been found
            expect(code).not.toBeNull();
            if (code == null)
                return;

            // Expect it to be the correct code
            expect(code.code).toEqual(CodeVals.code);
            expect(code.user.toString()).toEqual(CodeVals.user);
            expect(code.purpose).toEqual(CodeVals.purpose);
        });
    });
});