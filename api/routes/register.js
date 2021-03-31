// Import libraries for handling passwords, Google authentication, and JWTs
const bcryptUtil = require('./lib/bcryptUtil');
const googleOAuth = require('./lib/googleOAuth');
const jwt = require('./lib/jwtUtils');

// Import the Mongoose User model for database interaction
const User = require('../models/user'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/register
const constructPath = require('./lib/constructpath');
const endpointPath = '/register';

// Validation function for local registration request bodies
// TODO: condense into regex checks (can add regex to the user schema)
// TODO: sanitize inputs
function verifyLocal(body, res)
{
    // Content existence checks
    // No body sent
    if (!body) {
        res.status(422).json({ error: "No body included in request" });
        return false;
    }

    // No name sent
    if (!body.name) {
        res.status(422).json({ error: "No name included in request" });
        return false;
    }

    // No password sent
    if (!body.password) {
        res.status(422).json({ error: "No password included in request" });
        return false;
    }

    // No email sent
    if (!body.email) {
        res.status(422).json({ error: "No email included in request" });
        return false;
    }

    // Content validation checks
    // Name checks
    if (body.name.length < 8 || body.name.length > 32) {
        res.json({ error: "Display name must be between 8 and 32 characters" });
        return false;
    }

    if (typeof(body.name) != "string") {
        res.status(422).json({ error: "Display name must be a string" });
        return false;
    }

    // Many of these could be solved with regex, so I will stop this here for now

    return true;
}

// Assumed a user might not be logged in to access any of these endpoints
// Registration is always an unauthenticated action initially
function safeActions(router) {
    router.post(constructPath(endpointPath, '/'), async function(req, res) {
        // Verify neccessary information is provided
        let isValid = await verifyLocal(req.body, res);
        if (!isValid)
            return;

        // Begin registration process
        await bcryptUtil.encryptPassword(req.body.password, function(err, hash) {
            // If an error occured during password encryption, display an error
            if (err) {
                res.status(500).json({ error: err });
                return;
            }

            // Attempt to save registered user
            let user = new User({
                display: req.body.name,
                email: req.body.email,
                password: hash
            });
        
            user.save()
            .then(async user => {
                // If we get here, then the user was successfully registered
                // No error, so we can generate and send a JWT
                await jwt.sendJWTBody(user, res);
            })
            .catch(function(err) {
                // Sends the error as output
                if (err.keyPattern && err.keyPattern.email)
                    res.status(422).json({ error: "An account with this email already exists" });
                else
                    res.status(422).json({ error: err });
            });
        });
    });

    router.post(constructPath(endpointPath, '/google'), async function(req, res) {
        // Verify necessary information is provided
        let { isValid, ticket } = await googleOAuth.verifyGoogle(req.body, res);
        if (!isValid)
            return;

        // Begin registration process
        await googleOAuth.registerGoogle(res, ticket);
    });
}


function use(router, authenticatedRouter) {
    // Assign the router to be used
    safeActions(router);
}

// Export the use function, enabling the register endpoint
module.exports = {
    use: use
};
