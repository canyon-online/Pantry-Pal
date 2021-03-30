const mongoose = require('mongoose');

const ingredientSchema = new mongoose.Schema({ 
    author: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    name: {
        // Ideally only want one copy of any given ingredient
        type: String,
        required: [true, "Ingredient name is required"],
        unique: true,
        dropDups: true
    },
    dateCreated: {
        type: Date,
        default: Date.now
        // Should not have a "required" field, as default should generate it
    },
    image: {
        type: String,
        // Optional for ingredients
    },
});

module.exports = mongoose.model('Ingredient', ingredientSchema); 
