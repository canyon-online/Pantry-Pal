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
const ingredient = require('../models/ingredient');
const endpointPath = '/recipes';

// Given a list of recipes, populate the authors, ingredients, and isLiked field
async function populateRecipes(recipes, userId) {
    var currentUser;

    // If the user is logged in, we want to get the user to create an isLiked field
    if (userId)
        currentUser = await User.findById(userId);

    // Use the models to populate an array
    await User.populate(recipes, { path: 'author', model: 'User', select: 'display' });
    await Ingredient.populate(recipes, { path: 'ingredients', model: 'Ingredient', select: 'name' });
    
    // Populates an isLiked field based on the current user
    // There is likely a better way to do this
    if (currentUser) {
        recipes.forEach(async function(recipe) {
            recipe.set('isLiked', currentUser.favorites.includes(recipe._id), { strict: false });
        }); 
    }  

    return recipes;
}

// Assumed a user might not be logged in to access any of these endpoints
function safeActions(router) {
    // GET /, returns list of recipes matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        var currentUser;
        const { totalRecords, query } = await search(Recipe, req);

        // Modify the query to remove irrelevant fields from results
        query.select('-__v');

        query.exec(async function(err, recipes) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Now we want to reveal the user display name for each record found
            // We also want to reveal ingredient data for each record found
            await populateRecipes(recipes, req.headers.userId);

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
        Recipe.findByIdAndUpdate(req.params.id, { $inc: { 'numHits': 1 } }, { new: true }, async function(err, recipe) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing recipe
            if (!recipe) {
                res.status(404).json({ error: "There is no recipe with that id" });
                return;
            }

            // Now we want to reveal the user display name for each record found
            // We also want to reveal ingredient data for each record found
            await populateRecipes([recipe], req.headers.userId);

            res.json(recipe);
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

    // POST /:id/favorite, add the specified recipe to the current user's favorites
    // TODO: refactor this greatly - very poorly implemented
    router.post(constructPath(endpointPath, '/:id/favorite'), async function(req, res) { 
        if (!validateObjectId(req.params.id)) {
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }

        // Get the userid from the headers
        const userId = req.headers.userId;

        // Attempt to retrieve the specified recipe
        Recipe.findById(req.params.id, 'numFavorite', async function(err, recipe) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }
        
            // Id does not point to an existing recipe
            if (!recipe) {
                res.status(404).json({ error: "There is no recipe with that id" });
                return;
            }

            // Get the current user and add this to their favorites
            User.find({ _id: userId, favorites: req.params.id }, function(err, user) {
                if (err) {
                    res.status(422).json({ error: "Failed to execute query" });
                    return;
                }

                if (user.length == 0) {
                    // Current user does not have this as a favorite, so add it
                    User.findByIdAndUpdate(userId, { $push: { favorites: req.params.id } }, async function(err, u) {
                        Recipe.findByIdAndUpdate(req.params.id, { $inc: { 'numFavorites': 1 } }, { new: true }, function(err, recipe) {
                            res.json({ numFavorites: recipe.numFavorites });
                        });
                    });
                } else {
                    // Current user does has this as a favorite, so remove it
                    User.findByIdAndUpdate(userId, { $pull: { favorites: req.params.id } }, async function(err, u) {
                        Recipe.findByIdAndUpdate(req.params.id, { $inc: { 'numFavorites': -1 } }, { new: true }, function(err, recipe) {
                            res.json({ numFavorites: recipe.numFavorites });
                        });
                    });
                }
            });

        });
    });

    // PATCH /:id, modifies recipe fields by id
    router.patch(constructPath(endpointPath, '/:id'), async function(req, res) {
        // Attempt to update recipe
        Recipe.findByIdAndUpdate(req.params.id, req.body)
        .then(function(recipe) {
            res.json(recipe);
        })
        .catch(function() {
            res.status(422).send("Recipe update failed.");
        });
    });

    // DELETE /:id, deletes a recipe by id
    router.delete(constructPath(endpointPath, '/:id'), async function(req, res) {
        // Attempt to delete recipe
        Recipe.findById(req.params.id, async function(err, recipe) {
            if (!recipe) {
                res.status(404).json({ error: "There is no recipe with that id" });
            } else if (recipe.author != req.headers.userId) {
                // Check if the user ids match (user is authorized to modify this resource)
                res.status(403).json({ error: "The currently logged in user is not authorized to modify this recipe"});
                return;
            } else {
                Recipe.findByIdAndRemove(req.params.id)
                .then(function() { 
                    res.json({ success: "Recipe successfully deleted" }); 
                })
                .catch(function(err) {
                    res.status(500).json( { error: "Recipe deletion failed." });
                })
            }
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