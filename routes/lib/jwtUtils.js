// Import the JWT library
const jwt = require('jsonwebtoken');

// Expiry time is in seconds
const jwtExpiryTime = process.env.JWT_EXPIRY_TIME || 300;
const jwtKey = process.env.JWT_SECRET_KEY || 'Secret';

async function generateJWT(oid) {
    const token = jwt.sign({ oid }, jwtKey, {
        algorithm: 'HS256',
        expiresIn: jwtExpiryTime
    });

    return token;
}

module.exports = {
    generateJWT: generateJWT,
    maxAge: jwtExpiryTime * 1000
}
