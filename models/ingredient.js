const mongoose = require('mongoose');

const ingredientSchema = new mongoose.Schema({ 
    author: {
        type: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
        // Author only included if a user creates the ingredient, which it is assumed will not always
        // be the case
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
