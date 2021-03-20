const mongoose = require('mongoose');

// Convert the user object to a schema using the validation function
const userSchema = new mongoose.Schema({ 
    display: {
        type: String,
        required: [true, "Display name is required"]
    },
    email: {
        type: String,
        required: [true, "Email is required"]
    },
    // Could perhaps generate a "display id" for each user, as Mongo already automatically generates
    // a ObjectId primary key, which *is* usable, but is kind of ugly and reveals when a user was created
    // displayId: {
    //     type: int
    // },
    password: {
        type: String
    },
    googleToken: {
        type: String
    },
    dateSignedUp: {
        type: Date,
        default: Date.now
        // Should not have a "required" field, as default should generate it
    },
    recipeList: {
        // A simple array might not be the most optimal approach for this and for favorites
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Recipe'}],
    },
    favorites: {
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Recipe' }],
    }
});

// Validation function to ensure that the user has either signed up locally or through Google
userSchema.pre('validate', function(next) {
    if (this.password || this.googleToken) {
        next();
    } else {
        next(new Error('Attempted to create a user without a passwword or googleToken'));
    }
});

module.exports = mongoose.model('User', userSchema); 
