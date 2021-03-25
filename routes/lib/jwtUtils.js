// Import the JWT library
const jwt = require('jsonwebtoken');

// Expiry time is in seconds
const jwtExpiryTime = process.env.JWT_EXPIRY_TIME * 1000;
const jwtKey = process.env.JWT_SECRET_KEY;

// TODO: convert to asynchronous implementations

// Generate a JWT using the key provided and a user's object id
// Currently a synchronous implementation
function generateJWT(oid, name) {
    const token = jwt.sign({ userId: oid, name: name }, jwtKey, {
        algorithm: 'HS256',
        expiresIn: jwtExpiryTime
    });

    return token;
}

// Verify a JWT, returning either the payload of the token or null
// Currently a synchronous implementation
function verifyJWT(token) {
    try {
        return jwt.verify(jwtKey, token);
    } catch(err) {
        return null;
    }
}


// Function to generate and send a JWT 
async function genAndSendToken(user, res) {
    // Generate a JWT using the user objectid
    const token = await generateJWT(user._id, user.display);

    // Send the user a JWT token to store to save their session
    res.cookie("token", token, { httpOnly: true, maxAge: jwtExpiryTime });
    res.json({ token: token, expiresIn: jwtExpiryTime });
}



// Export pertinent functions and objects related to JSON Web Tokens
module.exports = {
    generateJWT: generateJWT,
    sendJWT: genAndSendToken,
    verifyJWT: verifyJWT,

    maxAge: jwtExpiryTime
};
