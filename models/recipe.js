const mongoose = require('mongoose');

const Image = require('./image');

const recipeSchema = new mongoose.Schema({ 
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    name: {
        type: String,
        required: [true, "Recipe name is required"]
    },
    ingredients: {
        type: [{ type: mongoose.Schema.Types.ObjectId, ref: 'Ingredient' }]
    },
    directions: {
        type: String,
        required: [true, "Recipes require directions"]
    },
    dateCreated: {
        type: Date,
        default: Date.now
        // Should not have a "required" field, as default should generate it
    },
    tags: {
        type: [String]
    },
    image: {
        type: String,
        // Want some sort of validation here to avoid being able to load images from other sites
        required: [true, "Recipes require some image to display the end result"]
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
    difficulty: {
        type: Number,
        min: 0,
        max: 10
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
recipeSchema.post('save', async function(recipe) {
    const image = recipe.image;

    let updatedImg = await Image.findOneAndUpdate({ uriLocation: image }, { unused: false });

    return;
});

// On intent to delete a recipe, mark the indicated image as unused so it will be deleted
recipeSchema.pre('delete', async function(next) {
    const image = this.image;

    let updatedImg = await Image.findOneAndUpdate({ uriLocation: image }, { unused: true });

    next();
});

module.exports = mongoose.model('Recipe', recipeSchema); 
