const mongoose = require('mongoose');

// Require the Image model to properly keep track of what images are in use
const Image = require('./image');

// Require the User model to keep track of recipes in a list
const User = require('./user');

const recipeSchema = new mongoose.Schema({ 
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    name: {
        type: String,
        required: [true, "Recipe name is required"],
        validate: {
            validator: function(v) {
                return /^[\p{L}\p{M}0-9-, ]{5,64}$/u.test(v);
            },
            message: props => `${props.value} is not an accepted name`
        }
    },
    ingredients: {
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Ingredient' }]
    },
    directions: {
        type: String,
        required: [true, "Recipes require directions"],
        validate: {
            validator: function(v) {
                return /^.{1,4096}$/us.test(v);
            },
            message: props => `These directions are too long`
        }
    },
    dateCreated: {
        type: Date,
        default: Date.now
        // Should not have a "required" field, as default should generate it
    },
    tags: {
        type: [String],
        validate: {
            validator: function(v) {
                return /^[\p{L}\p{M}0-9-,  \p{Emoji_Presentation}]{0,16}$/u.test(v);
            },
            message: props => `${props.value} is not an accepted tag name`
        }
    },
    image: {
        type: String,
        validate: {
            validator: function(v) {
                // Check the format of the image provided
                return v.length != 0 ? /^\/images\/([A-Za-z0-9])*.png$/.test(v) : true;
            },
            message: props => `${props.value} is not a valid image uri`
        }
    },
    numFavorites: {
        type: Number,
        min: 0,
        default: 0
    },
    numHits: {
        type: Number,
        min: 0,
        default: 0
    },
    rating: {
        type: Number,
        min: 0,
        max: 5,
        default: 0
    },
    serves: {
        type: Number,
        min: 0,
        max: 50,
        default: 1
    }
});

// Before built-in type validation, convert the ingredients to ids
recipeSchema.pre('validate', function(next) {
    let ingredients = [];
    const ingredientCount = this.ingredients.length;

    for (var i = 0; i < ingredientCount; i++) {
        ingredients[i] = mongoose.Types.ObjectId(this.ingredients[i]);
    }

    this.ingredients = ingredients;

    next();
});

// On successful save, mark the indicated image as used so it won't be deleted
// Also update the user's recipe list with the new recipe
recipeSchema.post('save', async function(recipe) {
    const image = recipe.image;
    await Image.findOneAndUpdate({ uriLocation: image }, { unused: false });

    User.findByIdAndUpdate(recipe.author, {
        $push: { recipeList: recipe._id }
    }, function(err, user) {
        if (err)
            throw new Error(err);
    });

    return;
});

// On intent to delete a recipe, mark the indicated image as unused so it will be deleted
recipeSchema.post('delete', async function(recipe) {
    const image = recipe.image;
    await Image.findOneAndUpdate({ uriLocation: image }, { unused: true });

    // Also update the user's recipe list to indicate removal
    User.findByIdAndUpdate(recipe.author, {
        $pull: { recipeList: this._id }
    }, function(err, user) {
        if (err)
            throw new Error(err);
    });

    // Remove this from any any favorites list (unsure of how computationally intense this may be)
    User.updateMany({ 
        favorites: { $all: [recipe._id]}
    }, {
        $pull: {favorites: recipe._id}
    }, function(err, user) {
        if (err)
            throw new Error(err);
    });

    next();
});

module.exports = mongoose.model('Recipe', recipeSchema); 
