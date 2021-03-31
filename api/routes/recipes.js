// Import libraries for handling database operations
const mongoose = require('mongoose');
const search = require('./lib/search');
const validateObjectId = require('./lib/validateObjectId');

// Import the relevant models
const Ingredient = require('../models/ingredient');
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/recipes
const constructPath = require('./lib/constructpath');
const endpointPath = '/recipes';

// Given a list of recipes, recover the users and return a list of them
async function getUsersForRecipes(recipes) {
    for (var i = 0; i < recipes.length; i++) {
        recipes[i].author = await User.findById(recipes[i].author, '_id display').exec();
    }

    return recipes;
}

// Given a list of recipes, recover the ingredients and return a list of them
async function getIngredientsForRecipes(recipes) {
    for (var i = 0; i < recipes.length; i++) {
        let currentIngredients = recipes[i].ingredients;

        for (var j = 0; j < currentIngredients.length; j++) {
            currentIngredients[j] = { _id: currentIngredients[i] }
        }

        if (currentIngredients.length != 0) {
            // Do it in one query this way, unsure if this is computationally efficient
            recipes[i].ingredients = await Ingredient.find({ $or: currentIngredients }, '-__v');
        }
    }

    return recipes;
}

// Assumed a user might not be logged in to access any of these endpoints
function safeActions(router) {
    // GET /, returns list of recipes matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        const { totalRecords, query } = await search(Recipe, req);

        // Modify the query to remove irrelevant fields from results
        query.select('-__v');

        await query.exec(async function(err, recipes) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Now we want to reveal the user display name for each record found
            // Perhaps not good to mutate the input like done here?
            recipes = await getUsersForRecipes(recipes);

            // We also want to expose ingredient information
            recipes = await getIngredientsForRecipes(recipes);

            // No error in query execution, so respond with typical search output
            res.json({ totalRecords: totalRecords, filteredRecords: recipes.length, recipes: recipes });
        });
    });

    // GET /:id, returns the recipe indicated by the id
    router.get(constructPath(endpointPath, '/:id'), async function(req, res) {
        if (!validateObjectId(req.params.id)) {
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }

        // Attempt to retrieve the recipe
        Recipe.findById(req.params.id, async function(err, recipe) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing recipe
            if (!recipe) {
                res.status(404).json({ error: "There is no recipe with that id" });
                return;
            }

            // Now we want to reveal some user information for the recipe found
            // We transform the recipe into a list temporarily so this function works for it
            recipe = await getUsersForRecipes([recipe]);

            // We also want to expose ingredient information
            recipe = await getIngredientsForRecipes([recipe[0]]);

            res.json(recipe[0]);
        });
    });
}

// Assumed a user is logged in to access any of these endpoints
function authenticatedActions(router) {
    // POST /, creates a recipe and returns it
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Ensure that a recipe was properly passed to this endpoint
        if (!req.body || !req.body.name || !req.body.directions || !req.body.image) {
            // Could probably rely on the recipe schema to throw this error on saving
            res.status(422).json({ error: "Missing required recipe properties in request" });
            return;
        }

        // Get the userid from the headers
        const userId = req.headers.userId;

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

    // POST /:id/favorite, creates a recipe and returns it
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        // Ensure that a recipe was properly passed to this endpoint
        if (!req.body || !req.body.name || !req.body.directions || !req.body.image) {
            // Could probably rely on the recipe schema to throw this error on saving
            res.status(422).json({ error: "Missing required recipe properties in request" });
            return;
        }

        // Get the userid from the headers
        const userId = req.headers.userId;

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
}

function use(router, authenticatedRouter) {
    // Assign the routers to be used
    safeActions(router);
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the recipe endpoint
module.exports = {
    use: use
};