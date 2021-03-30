// Verification codes to be sent in emails, such as forgotten password emails or verification
const mongoose = require('mongoose');

// The duration that generated codes should be valid by default in minutes
const codeDuration = process.env.DEFAULT_CODE_DURATION || 15;

const codeSchema = new mongoose.Schema({ 
    code: {
        type: String,
        required: [true, "Actual code value is required"]
    },
    user: {
        type: mongoose.Schema.Types.ObjectId, 
        ref: 'User'
    },
    purpose: {
        // Logging the purpose of the code
        type: String
    },
    expiresAt: {
        type: Date,
        default: () => new Date(+new Date() + 1000*60*codeDuration)
    }
});

// Prevent multiple pending codes for the same purpose for a user
codeSchema.pre('save', async function() {
    await codeModel.deleteMany({ user: this.user, purpose: this.purpose });
});

// Whenever a code is generated, remove all codes past their expiration date
codeSchema.post('save', async function() {
    // Could perhaps expand this to log deleted codes as well, but logging is not yet really implemented
    await codeModel.deleteMany({ expiresAt: { $lte: new Date() } });
});

// Create the codeModel early to guarantee the middleware functions have access to the model
const codeModel = mongoose.model('verificationCode', codeSchema);

module.exports = codeModel;
