// Refresh token endpoint

// Import libraries and classes necessary for handling refresh tokens
const jwt = require('./lib/jwtUtils');
const User = require('../models/user'); 
const RefreshToken = require('../models/refreshToken');

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/refresh
const constructPath = require('./lib/constructpath');
const endpointPath = '/refresh';

// Assumed a user might not be logged in to access any of these endpoints
// When utilizing a refresh token, it is authenticated slightly differently, so it uses the safe router
function safeActions(router) {
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Ensure that a refresh token is provided in the request body
        if (!req.body || !req.body.refreshToken) {
            res.status(400).json({ error: "No refresh token included in request body" });
            return;
        }

        // Check if the token exists in the database
        RefreshToken.findOneAndUpdate({ token: req.body.refreshToken }, { $inc: { 'uses': 1 } }, { new: true }, async function(err, token) {
            // Token does not exist
            if (!token) {
                res.status(401).json({ error: "Invalid refresh token" });
                return;
            }

            if (new Date() >= token.expiresAt) {
                // Token exists but is expired
                res.status(410).json({ error: "That refresh token has expired" });
                return;
            }

            // Token exists and is still valid, so generate a new JWT and send to the user
            // Get the user from the token
            const user = await User.findById(token.user);
            await jwt.sendJWTBody(user, res);

            // If the token is close to expiring and the user is active, push the expiry back a day from now
            if (token.expiresAt - new Date() <= 86400000) {
                await RefreshToken.findByIdAndUpdate({ _id: token._id }, { expiresAt: new Date(+new Date() + 1000*60*1440)});
            }
        });
    });
}


function use(router, authenticatedRouter) {
    // Assign the router to be used
    safeActions(router);
}

// Export the use function, enabling the login endpoint
module.exports = {
    use: use
};