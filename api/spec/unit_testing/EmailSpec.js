describe("EmailUtils", function() {
    var EmailLib = require('../../routes/lib/emailUtils');

    const CodeVals = {
        digits: 6,
        id: "id",
        purpose: "purpose"
    }

    const EmailVals = {
        id: "id",
        name: "name",
        email: "email"
    }

    // Create a token so we can create a verification code
    var token;

    it("should generate a verification code", function() {
        // Generate a verification code using the parameters
        token = EmailLib.generateVerificationCode(CodeVals.digits, CodeVals.id, CodeVals.purpose);

        // We expect the generated code to be valid
        expect(token).validCode(CodeVals.digits, CodeVals.id, CodeVals.purpose);
    });

    it("should send a verification email to the user", function() {
        // Send a verification email to a user
        token = EmailLib.sendVerificationEmail(EmailVals.id, EmailVals.name, EmailVals.email);

        // We expect
    });

    it("should send a 'forgot password' email to the user", function() {
        // Send a 'forgot password' email to a user
        token = EmailLib.sendForgotPasswordEmail(EmailVals.id, EmailVals.name, EmailVals.email);

        // We expect
    });
});