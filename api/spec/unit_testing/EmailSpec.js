describe("EmailUtils", function() {
    const Code = require('../../models/verificationCode');
    const EmailLib = require('../../routes/lib/emailUtils');

    // Code generation values taht will be used for testing
    const CodeVals = {
        digits: 6,
        id: "605927d16847e332654180c7",
        purpose: "purpose"
    };

    // Email values that will be used for testing
    const EmailVals = {
        id: "605927d16847e332654180c7",
        name: "name",
        email: "postmaster@pantrypal.hasty.cc"
    };

    // Create a token so we can create a verification code
    var token, promise;

    // Example of an async version, which is perhaps easier than nesting .then()s
    it("should generate verification codes", async function() {
        // Generate a verification code using the parameters
        // This returns only the generated code in digits, not the DB object
        token = EmailLib.generateVerificationCode(CodeVals.digits, CodeVals.id, CodeVals.purpose);

        // We expect the generated code to be in-line with our parameters
        expect(token.length).toEqual(CodeVals.digits);

        // Now check the database for this code record (and delete it to clean up after ourselves)
        token = await Code.findOneAndDelete({
            code: token,
            user: CodeVals.id,
            purpose: CodeVals.purpose
        });
            
        expect(token).not.toEqual(undefined);

    });

    it("should robustly generate verification codes", function() {
        // Generate another code with a differing length
        token = EmailLib.generateVerificationCode(CodeVals.digits + 5, CodeVals.id, CodeVals.purpose);

        expect(token.length).toEqual(CodeVals.digits + 5);

        // Now check the database for this code record (and delete it to clean up after ourselves)
        Code.findOneAndDelete({
            code: token,
            user: CodeVals.id,
            purpose: CodeVals.purpose
        }, function(code) {
            expect(code).not.toEqual(undefined);
        });
    });

    // Testing these actual email functions might not be conducive to actual functionality on non-production machines
    it("should send a verification email to the user", function() {
        // Send a verification email to a user, this returns a promise
        promise = EmailLib.sendVerificationEmail(EmailVals.id, EmailVals.name, EmailVals.email);

        promise.then(function(success) {
            // We expect this to be successful in all cases, if emailing is set up correctly
            expect(success).toEqual(true);
        });
    });

    it("should send a 'forgot password' email to the user", function() {
        // Send a 'forgot password' email to a user, this returns a promise
        promise = EmailLib.sendForgotPasswordEmail(EmailVals.id, EmailVals.name, EmailVals.email);

        promise.then(function(success) {
            // We expect this to be successful in all cases, if emailing is set up correctly
            expect(success).toEqual(true);
        });
    });
});