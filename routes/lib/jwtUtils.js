// Import the JWT library
const jwt = require('jsonwebtoken');

// Expiry time is in seconds
const jwtExpiryTime = process.env.JWT_EXPIRY_TIME * 1000;
const jwtKey = process.env.JWT_SECRET_KEY;

// TODO: convert to asynchronous implementations

// Generate a JWT using the key provided and a user's object id
// Currently a synchronous implementation
function generateJWT(oid, name, verified) {
    const token = jwt.sign({ userId: oid, name: name, verified: verified }, jwtKey, {
        algorithm: 'HS256'
    });

    return token;
}

// Verify a JWT, returning either the payload of the token or null
// Currently a synchronous implementation
function verifyJWT(token) {
    try {
        return jwt.verify(token, jwtKey);
    } catch(err) {
        console.log(err);
        return null;
    }
}

// Refresh a currently valid JWT, returns true if the token is valid and not expired
// Currently a synchronous implementation
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

// Function to send a JWT with a setcookie header
async function sendTokenHeader(token, res) {
    // Send the user a JWT token to store to save their session
    res.cookie("token", token, { httpOnly: true, maxAge: jwtExpiryTime });
}

// Function to generate and send a JWT in the body of a response
async function sendTokenBody(user, res) {
    // Generate a JWT using the user objectid
    const token = await generateJWT(user._id, user.display, user.verified);

    // Send the user a JWT token to store to save their session
    await sendTokenHeader(token, res);
    res.json({ token: token, expiresIn: jwtExpiryTime });
}


// Export pertinent functions and objects related to JSON Web Tokens
module.exports = {
    generateJWT: generateJWT,
    sendJWTHeader: sendTokenHeader,
    sendJWTBody: sendTokenBody,
    refreshJWT: refreshJWT,
    verifyJWT: verifyJWT,

    maxAge: jwtExpiryTime
};
