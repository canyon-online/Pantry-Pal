// Import libraries for handling passwords, Google authentication, and JWTs
const bcryptUtil = require('./lib/bcryptUtil');
const googleOAuth = require('./lib/googleOAuth');
const jwt = require('./lib/jwtUtils');

// Import the Mongoose User model for database interaction
const User = require('../models/user'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/register
const endpointPath = '/register';

// Function to concatenate paths
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

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

// Callback function for local registration, called from the encryptPassword
// function. It saves the user to the database and will begin the login process.
async function onPasswordEncrypt(error, body, res, hashword)
{
    // If an error occured during password encryption, display an error
    if (error != null)
        res.status(422).json({ error: error });

    // Attempt to save registered user
    let user = new User({
        display: body.name,
        email: body.email,
        password: hashword
    });

    user.save()
    .then(async user => {
        // If we get here, then the user was successfully registered
        // Now, the user has to be sent a verification email

        // No error, so we can generate and send a JWT
        await jwt.sendJWT(user, res);
    })
    .catch(function(err) {
        // Sends the error as output. If there is no ._message attribute, then
        // the error has to do with duplicate emails.
        res.status(422).json({ error: err._message || "Duplicate email" });
    });
}


function use(router) {
    router.post(constructPath(endpointPath, '/'), async function(req, res) {
        // Verify neccessary information is provided
        let isValid = await verifyLocal(req.body, res);
        if (!isValid)
            return;

        // Begin registration process
        // onPasswordEncrypt is given as a callback, called after the password is encrypted
        await bcryptUtil.encryptPassword(req.body, onPasswordEncrypt, res);
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

// Export the register object containing the use function
module.exports = {
    use: use
};
