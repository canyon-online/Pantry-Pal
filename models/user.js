const mongoose = require('mongoose');

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
    // This is not a scalable way of implementing this
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
    if (this.password || this.google) {
        next();
    } else {
        next(new Error('Attempted to create a user without a password or googleToken'));
    }
});

module.exports = mongoose.model('User', userSchema); 
