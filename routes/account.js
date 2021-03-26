// Import libraries for handling JWTs and emailing
const jwt = require('./lib/jwtUtils');
const emailUtil = require('../routes/lib/emailUtils');
const mongoose = require('mongoose');

// Import the relevant models
const User = require('../models/user'); 
const Code = require('../models/verificationCode'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/account
const endpointPath = '/account';

// Function to concatenate paths
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

// Given 3 search parameters, attempt to find a verification code and delete it
async function getCode(verifCode, userId, purpose) {
    const code = await Code.findOneAndDelete({ code: verifCode, user: mongoose.Types.ObjectId(userId), purpose: purpose });

    return code
}

function use(router) {
    // Assumed a user is logged in to access this endpoint
    router.post(constructPath(endpointPath, '/verify'), async function(req, res) { 
        // Ensure that a code was properly passed to this endpoint
        if (!req.body || !req.body.code) {
            res.status(422).json({ error: "A verification code must be supplied for this request" });
            return;
        }

        // Get the userid from the JWT (can assume that there is a valid token)
        const { userId } = jwt.verifyJWT(req.cookies.token);

        // Attempt to find the code by the request body
        const retrievedCode = await getCode(req.body.code, userId, "Email Verification");

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

    // Assumed a user is logged in to access this endpoint
    router.post(constructPath(endpointPath, '/verify/requestEmail'), async function(req, res) {
        // Get the userid from the JWT (can assume that there is a valid token)
        const { userId } = jwt.verifyJWT(req.cookies.token);
        const user = await User.findById(userId);

        // Ensure that the user is not already verified
        if (user.verified) {
            res.status(409).json({ error: "The currently logged in user is already verified" })
            return;
        }

        // We found a user from the JWT, so send that user an email
        if (user) {

            // TODO: rate limit this endpoint

            try {
                emailUtil.sendVerificationEmail(user._id, user.display, user.email);
            } catch(err) {
                // Log email error
            }

            res.json({ success: "Email has been sent" })
            return;
        }

        // It should not be possible to get here
        res.status(422).json({ error: "Unknown error has occurred" });
    });

    // An unauthenticated user can access this endpoint
    router.post(constructPath(endpointPath, '/forgotPassword'), async function(req, res) {
        
    });

    // An unauthenticated user can access this endpoint
    router.post(constructPath(endpointPath, '/forgotPassword/requestEmail'), async function(req, res) {
        
    });
}

// Export the login object containing the use function
module.exports = {
    use: use
};