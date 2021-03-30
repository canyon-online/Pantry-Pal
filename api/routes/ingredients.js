// Import libraries for handling database operations
const jwt = require('./lib/jwtUtils');
const mongoose = require('mongoose');
const search = require('./lib/search');

// Import the relevant models
const User = require('../models/user'); 
const Ingredient = require('../models/ingredient'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/ingredients
const constructPath = require('./lib/constructpath');
const endpointPath = '/ingredients';

// Given a list of ingredients, recover the users and return a list of them
async function getUsersForIngredients(ingredients) {
    for (var i = 0; i < ingredients.length; i++) {
        ingredients[i].author = await User.findById(ingredients[i].author, '_id display').exec();
    }

    return ingredients;
}

// Assumed a user might not be logged in to access any of these endpoints
function safeActions(router) {
    // GET /, returns list of ingredients matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        const { totalRecords, query } = await search(Ingredient, req);

        let foundIngredients = await query.exec();

        // Now we want to reveal some user information for each record found
        foundIngredients = await getUsersForIngredients(foundIngredients);

        res.json({ totalRecords: totalRecords, filteredRecords: foundIngredients.length, ingredients: foundIngredients });
    });
}

// Assumed a user is logged in to access any of these endpoints
function authenticatedActions(router) {
    // POST /, creates an ingredient and returns it
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Ensure that an ingredient was properly passed to this endpoint
        if (!req.body || !req.body.name) {
            // Could probably rely on the ingredient schema to throw this error on saving
            res.status(422).json({ error: "Missing ingredient name in the request" });
            return;
        }

        // Get the userid from the JWT (can assume that there is a valid token)
        const token = req.headers.authorization.split(' ')[1];
        const { userId } = jwt.verifyJWT(token);

        // Attempt to create a new ingredient
        const ingredient = new Ingredient({
            author: mongoose.Types.ObjectId(userId),
            name: req.body.name,
            image: req.body.image || ''
        });

        ingredient.save().then(function(ingredient) {
            res.json(ingredient);
        }).catch(function(err) {
            res.status(422).json({ error: "Failed to create an ingredient with provided properties" });
        });
    });
}

function use(router, authenticatedRouter) {
    // Assign the routers to be used
    safeActions(router);
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the ingredients endpoint
module.exports = {
    use: use
};