describe("Account", function() {
    const Account = require('../../routes/account');
    const Code = require("../../models/verificationCode");

    // Constant testing values we will use for testing verification codes
    const CodeVals = {
        code: "123456",
        user: "605927d16847e332654180c7",
        purpose: "purpose"
    }

    it("should return nothing if the specified code does not exist", function() {
        // Returns a promise, so we have to fulfill the promise
        var codePromise = Account.getCode(CodeVals.code, CodeVals.user, CodeVals.purpose);

        // After fulfilling the promise, check
        codePromise.then(function(code) {
            expect(code).toEqual(undefined);
        });
    });

    it("should find and delete a verification code", function() {
        // To ensure we find a valid verification code, we have to generate one
        new Code({
            code: CodeVals.code,
            user: CodeVals.user,
            purpose: CodeVals.purpose
        }).save();

        // Attempt to find a verification code using parameters and delete it
        // Using example strings such as "userId" rather than actual ObjectIds, as it should not matter
        var codePromise = Account.getCode(CodeVals.code, CodeVals.user, CodeVals.purpose);

        codePromise.then(function(code) {
            // Expect a code to have been found
            expect(code).not.toEqual(undefined);

            // Expect it to be the correct code
            expect(code.code).toEqual(CodeVals.code);
            expect(code.user).toEqual(CodeVals.user);
            expect(code.purpose).toEqual(CodeVals.purpose);
        });
    });
});