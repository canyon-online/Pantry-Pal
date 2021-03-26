// Import libraries for handling JWTs and emailing
const jwt = require('./lib/jwtUtils');
const emailUtil = require('../routes/lib/emailUtils');
const mongoose = require('mongoose');

// Import the relevant models
const User = require('../models/user'); 
const Code = require('../models/verificationCode'); 
const { response } = require('express');

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/account
const endpointPath = '/account';

// Function to concatenate paths
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

// Given a string, attempt to locate a Code object
async function getCode(verifCode, userId) {
    const code = await Code.findOneAndDelete({ code: verifCode, user: mongoose.Types.ObjectId(userId) });

    return code
}

function use(router) {
    router.post(constructPath(endpointPath, '/verify'), async function(req, res) { 
        // Ensure that a code was properly passed to this endpoint
        if (!req.body || !req.body.code) {
            res.status(422).json({ error: "A verification code must be supplied for this request" });
            return;
        }

        // Get the userid from the JWT (can assume that there is a valid token)
        const { userId } = jwt.verifyJWT(req.cookies.token);

        // Attempt to find the code by the request body
        const retrievedCode = await getCode(req.body.code, userId);

        if (retrievedCode) {
            // Check to make sure the code is not expired (could potentially add this as a hook to the schema)
            if (new Date() >= retrievedCode.expiresAt) {
                res.status(410).json({ error: "That code has expired" });
                return;
            }

            // Valid code, so update the user's verified field
            await User.findByIdAndUpdate(userId, { verified: true });

            res.json({ success: "User has successfully been verified" });
        }
        else
            res.status(422).json({ error: "Invalid code" });
    });

    router.post(constructPath(endpointPath, '/verify/requestEmail'), async function(req, res) {
        
    });

    router.post(constructPath(endpointPath, '/forgotPassword'), async function(req, res) {
        
    });

    router.post(constructPath(endpointPath, '/forgotPassword/code'), async function(req, res) {
        
    });
}

// Export the login object containing the use function
module.exports = {
    use: use
};