// Import the JWT library
const jwt = require('jsonwebtoken');
const refreshToken = require('../../models/refreshToken.js');

// Import the refreshToken object
const RefreshToken = require('../../models/refreshToken.js');

// Expiry time is in seconds
const jwtExpiryTime = process.env.JWT_EXPIRY_TIME * 1000;
const jwtKey = process.env.JWT_SECRET_KEY || "secret";
const refreshTokenExpiryTime = process.env.REFRESH_TOKEN_DURATION || 604800000; // 7 days

// Generate a JWT using the key provided and a user's object id
function generateJWT(oid, name, verified) {
    const token = jwt.sign({ userId: oid, name: name, verified: verified }, jwtKey, {
        algorithm: 'HS256'
    });

    return token;
}

// Verify a JWT, returning either the payload of the token or null
function verifyJWT(token) {
    if (!token)
        return null;

    try {
        return jwt.verify(token, jwtKey);
    } catch(err) {
        console.log(err);
        return null;
    }
}

// Refresh a currently valid JWT, returns true if the token is valid and not expired
function refreshJWT(token, res) {
    // Only refresh valid tokens
    const payload = verifyJWT(token);

    if (payload) {
        const newToken = jwt.sign(payload, jwtKey, {
            algorithm: 'HS256'
        });

        if (res)
            sendTokenHeader(newToken, res);

        return true;
    }
    
    return false;
}

// Generate a refresh token, should only be done on login
function generateRefreshToken(uid) {
    // Generate a token with a simple random string in it
    const token = jwt.sign({ userId: uid, rGen: Math.random().toString(36).substring(7) }, jwtKey, {
        algorithm: 'HS256'
    });

    // Put the generated token in long-term database storage to be able to track abuse
    const rToken = new RefreshToken({
        token: token,
        user: uid
    });

    rToken.save().catch(function(err){
        // We failed to save the refresh token to the database, potential errors later
    });

    return token;
}


// Function to send a JWT with a header to indicate an updated JWT
async function sendTokenHeader(token, res) {
    // Send the user a JWT token to store to save their session
    res.set('Auth-Update', token);
}

// Function to generate and send a JWT in the body of a response
async function sendTokenBody(user, res) {
    // Generate a JWT using the user objectid
    const token = await generateJWT(user._id, user.display, user.verified);

    // Send the user a JWT token to store to save their session
    // await sendTokenHeader(token, res);
    res.json({ token: token, expiresIn: jwtExpiryTime });
}

// Function to generate and send a JWT and a Refresh Token in a response body
// Only to be called when a user logs in
async function sendLoginBody(user, res) {
    // Generate a JWT using the user objectid
    const token = await generateJWT(user._id, user.display, user.verified);
    const refreshToken = await generateRefreshToken(user._id);

    // Send the user a JWT token to store to save their session
    res.json({ token: token, expiresIn: jwtExpiryTime, refreshToken: refreshToken, refreshExpiresIn: refreshTokenExpiryTime });
}

// Export pertinent functions and objects related to JSON Web Tokens
module.exports = {
    generateJWT: generateJWT,
    generateRefreshToken: generateRefreshToken,
    sendJWTHeader: sendTokenHeader,
    sendJWTBody: sendTokenBody,
    sendLoginBody: sendLoginBody,
    refreshJWT: refreshJWT,
    verifyJWT: verifyJWT,

    maxAge: jwtExpiryTime
};
