// Check the database to ensure that it is set up for Ingredients
const Ingredient = require('../../../models/ingredient');

// This ingredientId is used in various unit tests
const ingredientId = "6063ede90cafeb2ca0abc729";

// Define a nice ingredient to use
const niceIngredient = {
    name: "Test"
}

// Use upsert to create an ingredient with this id
Ingredient.findByIdAndUpdate(ingredientId, niceIngredient, {
    new: true,
    upsert: true
}).exec();

// Export the ingredientId we create so tests can use them
module.exports.ingredientId = ingredientId;