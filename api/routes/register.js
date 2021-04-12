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

// Assumed a user might not be logged in to access any of these endpoints
// Registration is always an unauthenticated action initially
function safeActions(router) {
    router.post(constructPath(endpointPath, '/'), async function(req, res) {
        // Verify neccessary information is provided
        let isValid = (req.body && req.body.password)
        if (!isValid) {
            res.status(422).json({ error: "Missing required fields" });
            return;
        }
            
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
                await jwt.sendLoginBody(user, res);
            })
            .catch(function(err) {
                // Sends the error as output
                if (err.keyPattern && err.keyPattern.email)
                    res.status(422).json({ error: "An account with this email already exists" });
                else if (err._message == "User validation failed")
                    res.status(422).json({ error: "Failed to create an account with this name or email" });
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
