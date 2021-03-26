// Import the Mongoose Code model for database interaction
const Code = require('../../models/verificationCode'); 

// Crypto module for generating more secure numbers than Math.random can provide
const crypto = require('crypto');

// Nodemailer module for actual emailing
// const nodemailer = require('nodemailer');

// Generate a verification code of N digits to be sent to a user
function generateVerificationCode(digits, id, purpose) {
    const generatedCode = crypto.randomInt(0, Math.pow(10, digits)).toString(10);

    const code = new Code({
        code: generatedCode,
        user: id,
        purpose: purpose
    });

    code.save().catch(function(err) {
        console.log(err);
    });

    return generatedCode;
}

function sendVerificationEmail(id, name, email) {
    const verifCode = generateVerificationCode(process.env.CODE_LENGTH, id, "Email Verification");

    return;
}

module.exports = {
    sendVerificationEmail: sendVerificationEmail
}