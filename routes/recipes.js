// Import libraries for handling database operations
const jwt = require('./lib/jwtUtils');
const mongoose = require('mongoose');
const search = require('./lib/search');

// Import the relevant models
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/recipes
const endpointPath = '/recipes';

// Function to concatenate paths
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

// Given a list of recipes, recover the users and return a list of them
async function getUsersForRecipes(recipes) {
    for (var i = 0; i < recipes.length; i++) {
        recipes[i].author = await User.findById(recipes[i].author, '_id display').exec();
    }

    return recipes;
}

function use(router) {
    // All of these endpoints are authenticated actions
    // POST /, creates a recipe and returns it
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Ensure that a recipe was properly passed to this endpoint
        if (!req.body || !req.body.name || !req.body.directions || !req.body.image) {
            // Could probably rely on the recipe schema to throw this error on saving
            res.status(422).json({ error: "Missing required recipe properties in request" });
            return;
        }

        // Get the userid from the JWT (can assume that there is a valid token)
        const token = req.headers.authorization.split(' ')[1];
        const { userId } = jwt.verifyJWT(token);

        // Attempt to create a new recipe
        const recipe = new Recipe({
            author: mongoose.Types.ObjectId(userId),
            name: req.body.name,
            ingredients: req.body.ingredients,
            directions: req.body.directions,
            tags: req.body.tags,
            image: req.body.image,
            difficulty: req.body.difficulty
        });

        recipe.save().then(function(recipe) {
            res.json(recipe);
        }).catch(function(err) {
            res.status(422).json({ error: "Failed to create a recipe with provided properties" });
        });
    });

    // GET /, returns list of recipes matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        const { totalRecords, query } = await search(Recipe, req);

        let foundRecipes = await query.exec();

        // Now we want to reveal some user information for each record found
        foundRecipes = await getUsersForRecipes(foundRecipes);

        res.json({ totalRecords: totalRecords, filteredRecords: foundRecipes.length, recipes: foundRecipes });
    });
}

// Export the login object containing the use function
module.exports = {
    use: use
};