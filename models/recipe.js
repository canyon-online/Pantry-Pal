const mongoose = require('mongoose');

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
        required: [true, "Recipes require some image to display the end result"]
    },
    numFavorites: {
        type: Number,
        min: 0
    },
    numHits: {
        type: Number,
        min: 0
    },
    rating: {
        type: Number,
        min: 0,
        max: 5
    },
    difficulty: {
        type: Number,
        min: 0,
        max: 10
    }
});

module.exports = mongoose.model('Recipe', recipeSchema); 
