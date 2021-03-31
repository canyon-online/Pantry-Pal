// Import libraries for handling database operations
const mongoose = require('mongoose');
const search = require('./lib/search');

// Import the relevant models
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 

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
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing user
            if (!user) {
                res.status(404).json({ error: "Unable to find the current user" });
                return;
            }

            res.json(user);
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
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing user
            if (!user) {
                res.status(404).json({ error: "Unable to find the current user" });
                return;
            }

            // Strip the response of the password field
            user.password = null;

            res.json(user);
        }); 
    });

    // DELETE /me, returns success or error upon trying to delete the current user account
    router.patch(constructPath(endpointPath, '/me'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        // TODO: secure this with a verification code
        User.findByIdAndUpdate(userId, {
            disabled: true
        }, { omitUndefined: true, new: true }, async function(err, user) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing user
            if (!user) {
                res.status(404).json({ error: "Unable to find the current user" });
                return;
            }

            res.json({ success: "Current user has been disabled" });
        }); 
    });


    // GET /me/recipes, returns information about the current user's created recipes
    router.get(constructPath(endpointPath, '/me/recipes'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        User.findById(userId, 'recipeList', async function(err, user) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing user
            if (!user) {
                res.status(404).json({ error: "Unable to find the current user" });
                return;
            }

            let recipeList = user.recipeList;

            for (var i = 0; i < recipeList.length; i++) {
                recipeList[i] = await Recipe.findById(recipeList[i], '-__v');
            }

            res.json({ recipes: recipeList });
        }); 
    });

    // GET /me/favorites, returns information about the current user's favorite recipes
    router.get(constructPath(endpointPath, '/me/favorites'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;        

        // Attempt to retrieve the current user
        User.findById(userId, 'favorites', async function(err, user) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing user
            if (!user) {
                res.status(404).json({ error: "Unable to find the current user" });
                return;
            }

            let recipeList = user.favorites;

            for (var i = 0; i < recipeList.length; i++) {
                recipeList[i] = await Recipe.findById(recipeList[i], '-__v');
            }

            res.json({ recipes: recipeList });
        }); 
    });
}

function use(router, authenticatedRouter) {
    // Assign the routers to be used
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the users endpoint
module.exports = {
    use: use
};