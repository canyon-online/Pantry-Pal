// Import the user model
const User = require('../models/user'); 

// The Google Auth Library is required to validate any tokens we recieve
// The client_id should be filled in by an environmental variable
// https://www.npmjs.com/package/google-auth-library
// Decent tutorial on the topic (up to managing a user session): 
// https://blog.prototypr.io/how-to-build-google-login-into-a-react-app-and-node-express-api-821d049ee670
const { OAuth2Client } = require('google-auth-library');
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// The root path of this, which is concatenated to the router path
// In the current version, this is /api/register
const endpointPath = '/register';

// Function to concatenate the paths, in the event that this should become
// more complicated to avoid having to rewrite in a lot of spots
// This should probably be moved to a library folder but I'll hold of for now
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

function use(router) {
    // This could be split into multiple functions, if wanted for readability
    router.post(constructPath(endpointPath, '/'), function(req, res) { 
        res.send('Registering with local login (:');
    });

    router.post(constructPath(endpointPath, '/google'), function(req, res) {
        res.send('Registering with Google :)');
    });
}

// Exported object that enables the use of functions defined here in other files
// Currently, only the `use` function is relevant to be used in external files
// If anyone wants to do this another way please do because something about this
// does not feel 'correct' to me
var register = {
    use: use
}

// Export the register object containing the use function
module.exports = register;