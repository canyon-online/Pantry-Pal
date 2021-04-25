// Check the database to ensure that it is set up for Codes
const Code = require('../../../models/verificationCode');

// This codeId is just some random valid mongoDB id
const codeId = "6085b18bf2f7af37f0b2202a";

// This userId is used in various unit tests
const userId = require('./users.init').userId;

// Define a nice code to use
const niceCode = {
    code: "123456",
    user: userId,
    purpose: "purpose"
}

// Use upsert to create a code with this id
Code.findByIdAndUpdate(codeId, niceCode, {
    new: true,
    upsert: true,
    ignoreUndefined: true
}).exec();

// Export the codeId and our code values
module.exports.codeId = codeId;
module.exports.niceCode = niceCode;