// Tokens used to get new access tokens
// These last much longer, but inevitably expire and are only generated upon login
const mongoose = require('mongoose');

// The duration that generated token should be valid by default in minutes
const codeDuration = process.env.REFRESH_TOKEN_DURATION || 10080; // 7 days

const tokenSchema = new mongoose.Schema({ 
    token: {
        type: String,
        required: [true, "Tokens must inherently have a token string"]
    },
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    expiresAt: {
        type: Date,
        default: () => new Date(+new Date() + 1000*60*codeDuration)
    }
});

module.exports = mongoose.model('refreshToken', tokenSchema); 