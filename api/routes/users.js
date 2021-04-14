// Import libraries for handling database operations
const mongoose = require('mongoose');
const search = require('./lib/search');
const validateObjectId = require('./lib/validateObjectId');

// Import the relevant models
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 
const Ingredient = require('../models/ingredient');

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/recipes
const constructPath = require('./lib/constructpath');
const endpointPath = '/users';

// Given a user query, strip of any 'dangerous' search parameters
const stripUnsafeQuery = (query) => {
    query.password = null;
    query.google = null;
    query.verified = null;
    query.email = null;
    query.sortBy = null;

    return query;
}

// Given a list of recipes, filter and sort them in a "search"-like way
async function filterAndPopulateRecipes(req, user, path) {
    const limit = req.query.limit ? (parseInt(req.query.limit) > 20 ? 20 : parseInt(req.query.limit)) : 20;
    const offset = req.query.offset || 0;
    const sortBy = req.query.sortBy || 'numFavorites';
    const direction = req.query.direction || -1;

    // First populate the recipes so we can sort by them
    await Recipe.populate(user, { path: path, model: 'Recipe' });

    // Sort by the specified field in the specified dirction
    user[path].sort(function(a,b) {
        if (a[sortBy] > b[sortBy])
            return direction;
        else if (a[sortBy] < b[sortBy])
            return -direction;
        return 0;
    });

    // After sorting, get the group of recipes that we want
    user[path] = user[path].slice(offset * limit, offset * limit + limit);

    // Populate the remaining recipes
    await User.populate(user[path], { path: 'author', model: 'User', select: 'display' });
    await Ingredient.populate(user[path], { path: 'ingredients', model: 'Ingredient', select: 'name' });

    return user[path];
}

// Error handler for most /users endpoints
function handleUserQueryErrors(err, user, res, cb) {
    if (err) {
        res.status(422).json({ error: "Failed to execute query" });
        return;
    }

    // Id does not point to an existing user
    if (!user) {
        res.status(404).json({ error: "Unable to find the user" });
        return;
    }

    // Call the callback if there were no errors
    cb();
}

// Assumed a user is logged in to access any of these endpoints
// Any user endpoint should be authenticated to help prevent abuse
function authenticatedActions(router) {
    // GET /, returns list of users matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        // Strip the search fields of any risky search parameters
        req.query = stripUnsafeQuery(query);

        const { totalRecords, query } = await search(User, req);

        // Modify the query to remove irrelevant (and dangerous) fields from results
        query.select(['__id', 'display', 'recipeList', 'favorites']);

        await query.exec(function(err, users) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // No error in query execution, so respond with typical search output
            res.json({ totalRecords: totalRecords, filteredRecords: users.length, users: users });
        });  
    });

    // GET /me, returns information about the current user
    router.get(constructPath(endpointPath, '/me'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        User.findById(userId, '-password -__v', async function(err, user) {
            // Use an error handler 
            handleUserQueryErrors(err, user, res, function() {
                res.json(user);
            });
        }); 
    });

    // PATCH /me, returns information about the current user after modifying it
    router.patch(constructPath(endpointPath, '/me'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;      

        // Attempt to retrieve the current user
        User.findByIdAndUpdate(userId, {
            display: req.body.name,
            private: req.body.private
        }, { omitUndefined: true, new: true }, async function(err, user) {
            handleUserQueryErrors(err, user, res, function() {
                // Strip the response of the password field
                user.password = null;

                res.json(user);
            });
        }); 
    });

    // DELETE /me, returns success or error upon trying to delete the current user account
    router.delete(constructPath(endpointPath, '/me'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        User.findByIdAndUpdate(userId, {
            disabled: true
        }, { omitUndefined: true, new: true }, async function(err, user) {
            handleUserQueryErrors(err, user, res, function() {
                res.json({ success: "Current user has been disabled" });
            });            
        }); 
    });


    // GET /me/recipes, returns information about the current user's created recipes
    router.get(constructPath(endpointPath, '/me/recipes'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        User.findById(userId, 'recipeList', async function(err, user) {
            handleUserQueryErrors(err, user, res, async function() {
                // If we successfully got our recipes, convert the ids to their associated recipes

                user.recipeList = await filterAndPopulateRecipes(req, user, "recipeList");

                res.json({ recipes: user.recipeList });
            });  
        }); 
    });

    // GET /me/favorites, returns information about the current user's favorite recipes
    router.get(constructPath(endpointPath, '/me/favorites'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;        

        // Attempt to retrieve the current user
        User.findById(userId, 'favorites', async function(err, user) {
            handleUserQueryErrors(err, user, res, async function() {
                // If we successfully got our favorites, convert the ids to their associated recipes

                user.favorites = await filterAndPopulateRecipes(req, user, "favorites");

                res.json({ recipes: user.favorites });
            });
        }); 
    });

    // GET /:id, returns information about the specified user
    router.get(constructPath(endpointPath, '/:id'), async function(req, res) {
        if (!validateObjectId(req.params.id)) {
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }

        // Attempt to retrieve the specified user
        User.findById(req.params.id, 'display recipeList favorites', async function(err, user) {
            handleUserQueryErrors(err, user, res, async function() {
                res.json(user);
            });  
        }); 
    });

    // GET /:id/recipes, returns information about the specified user's created recipes
    router.get(constructPath(endpointPath, '/:id/recipes'), async function(req, res) {
        if (!validateObjectId(req.params.id)) {
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }       

        // Attempt to retrieve the specified user
        User.findById(req.params.id, 'recipeList', async function(err, user) {
            handleUserQueryErrors(err, user, res, async function() {
                // If we successfully got the recipes, convert the ids to their associated recipes

                user.recipeList = await filterAndPopulateRecipes(req, user, "recipeList");

                res.json({ recipes: user.recipeList });
            });  
        }); 
    });

    // GET /:id/favorites, returns information about the specified user's favorite recipes
    router.get(constructPath(endpointPath, '/:id/favorites'), async function(req, res) {
        if (!validateObjectId(req.params.id)) {
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }       

        // Attempt to retrieve the specified user
        User.findById(req.params.id, 'favorites', async function(err, user) {
            handleUserQueryErrors(err, user, res, async function() {
                // If we successfully got the favorites, convert the ids to their associated recipes
                
                user.favorites = await filterAndPopulateRecipes(req, user, "favorites");

                res.json({ recipes: user.favorites });
            });
        }); 
    });
}

function use(router, authenticatedRouter) {
    // Assign the routers to be used
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the users endpoint
module.exports = {
    handleUserQueryErrors: handleUserQueryErrors,
    stripUnsafe: stripUnsafeQuery,
    use: use
};