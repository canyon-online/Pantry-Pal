const mongoose = require('mongoose');
const emailUtil = require('../routes/lib/emailUtils');

const userSchema = new mongoose.Schema({ 
    display: {
        type: String,
        required: [true, "Display name is required"]
    },
    email: {
        type: String,
        required: [true, "Email is required"],
        unique: true,
        dropDups: true
    },
    // Could perhaps generate a "display id" for each user, as Mongo already automatically generates
    // a ObjectId primary key, which *is* usable, but is kind of ugly and reveals when a user was created
    // displayId: {
    //     type: int
    // },
    password: {
        type: String
    },
    avatar: {
        type: String
        // Can put a default here, but don't currently have one
    },
    google: {
        type: Boolean,
        default: false
    },
    dateSignedUp: {
        type: Date,
        default: Date.now
        // Should not have a "required" field, as default should generate it
    },
    recipeList: {
        // A simple array might not be the most optimal approach for this or for favorites
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Recipe' }]
    },
    favorites: {
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Recipe' }]
    },
    verified: {
        type: Boolean,
        default: false
    }
});

// Validation function to ensure that the user has either signed up locally or through Google
userSchema.pre('validate', function(next) {
    // Convert the email to lowercase before we do validation
    this.email = this.email.toLowerCase();

    if (this.password || this.google) {
        if (this.google)
            this.verified = true;
        next();
    } else {
        next(new Error('Attempted to create a user without a password or Google account'));
    }
});

// Whenever a new user is created successfully, send a verification email
userSchema.post('save', function(user) {
    // In some bizzare case where the email is nonexistent
    // Also does not send an email
    if (!user.email || user.google)
        return;

    // If the user is a google user, do not email and automatically verify them
    if (user.google)
        return;

    try {
        emailUtil.sendVerificationEmail(user._id, user.display, user.email);
    } catch(err) {
        // Log email error
    }

    return
});

module.exports = mongoose.model('User', userSchema); 
