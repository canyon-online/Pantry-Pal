// Import the user model
const User = require('../models/user'); 

// Import libraries for handling hashed passwords and google authentication
const bcryptUtil = require('./lib/bcryptUtil');
const googleOAuth = require('./lib/googleOAuth');

// Import our JWT library for use in generating tokens
const jwt = require('./lib/jwtUtils');

// The root path of this, which is concatenated to the router path
// In the current version, this is /api/login
const endpointPath = '/login';

// Function to concatenate the paths, in the event that this should become
// more complicated to avoid having to rewrite in a lot of spots
// This should probably be moved to a library folder but I'll hold off for now
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

// Ensures that passed data is formatted nicely and non-maliciously
async function verifyLocal(body, res)
{
    if (!body) {
        res.json({ error: "No body included in request" });
        return false;
    }

    if (!body.email || typeof(body.email) != "string") {
        res.json({ error: "No email included in request" });
        return false;
    }
        
    if (!body.password || typeof(body.password) != "string") {
        res.json({ error: "No password included in request" });
        return false;
    }

    return true;
}

async function loginLocal(email, password, res) {
    let user = await User.findOne({ email: email }).exec();

    // No user is found
    if (user == null) {
        res.json({ error: "Email and password combination failed to match any existing records" });
        return;
    }

    bcryptUtil.comparePassword(password, user, sendToken, res);
}

async function sendToken(error, user, res) {
    if (error != null) {
        res.json({ error: "Email and password combination failed to match any existing records" });
        return;
    }

    // Generate a JWT using the user objectid
    const token = await jwt.generateJWT(user._id);

    // Send the user a JWT token to store to save their session
    res.cookie("token", token, { maxAge: jwt.maxAge});
    res.json({ token: token, expiresIn: jwt.maxAge });
}

function use(router) {
    // This could be split into multiple functions, if wanted for readability
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Verify neccessary information is provided
        let isValid = await verifyLocal(req.body, res);
        if (!isValid)
            return;

        // Begin login process
        await loginLocal(req.body.email, req.body.password, res);
    });

    router.post(constructPath(endpointPath, '/google'), async function(req, res) {
        // Verify necessary information is provided
        let { isValid, ticket } = await googleOAuth.verifyGoogle(req.body, res);
        if (!isValid)
            return;

        // Begin login process
        await googleOAuth.loginGoogle(res, ticket);
    });
}

// Exported object that enables the use of functions defined here in other files
// Currently, only the `use` function is relevant to be used in external files
// If anyone wants to do this another way please do because something about this
// does not feel 'correct' to me
const login = {
    use: use
}

// Export the login object containing the use function
module.exports = login;