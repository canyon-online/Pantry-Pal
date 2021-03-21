// Import the user model
const User = require('../models/user'); 

// The root path of this, which is concatenated to the router path
// In the current version, this is /api/login
const endpointPath = '/login';

// Function to concatenate the paths, in the event that this should become
// more complicated to avoid having to rewrite in a lot of spots
// This should probably be moved to a library folder but I'll hold of for now
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

function use(router) {
    // This could be split into multiple functions, if wanted for readability
    router.post(constructPath(endpointPath, '/'), function(req, res) { 
        res.send('Hello, world!');
    });

    router.post(constructPath(endpointPath, '/google'), function(req, res) {
        res.send('Logging in with Google :)');
    });
}

// Exported object that enables the use of functions defined here in other files
// Currently, only the `use` function is relevant to be used in external files
// If anyone wants to do this another way please do because something about this
// does not feel 'correct' to me
var login = {
    use: use
}

// Export the login object containing the use function
module.exports = login;