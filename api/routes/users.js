// Import libraries for handling database operations
const mongoose = require('mongoose');
const search = require('./lib/search');
const validateObjectId = require('./lib/validateObjectId');

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
    router.patch(constructPath(endpointPath, '/me'), async function(req, res) {
        // Get the userid from the headers
        const userId = req.headers.userId;       

        // Attempt to retrieve the current user
        // TODO: secure this with a verification code
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
                let recipeList = user.recipeList;

                for (var i = 0; i < recipeList.length; i++) {
                    recipeList[i] = { _id: recipeList[i] }
                }

                if (recipeList.length != 0) {
                    // Do it in one query this way, unsure if this is computationally efficient
                    recipeList = await Recipe.find({ $or: recipeList }, '-__v');
                }
                    
                res.json({ recipes: recipeList });
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
                let recipeList = user.favorites;

                for (var i = 0; i < recipeList.length; i++) {
                    recipeList[i] = { _id: recipeList[i] }
                }

                if (recipeList.length != 0) {
                    // Do it in one query this way, unsure if this is computationally efficient
                    recipeList = await Recipe.find({ $or: recipeList }, '-__v');
                }

                res.json({ recipes: recipeList });
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
                let recipeList = user.recipeList;

                for (var i = 0; i < recipeList.length; i++) {
                    recipeList[i] = { _id: recipeList[i] }
                }

                if (recipeList.length != 0) {
                    // Do it in one query this way, unsure if this is computationally efficient
                    recipeList = await Recipe.find({ $or: recipeList }, '-__v');
                }
                    
                res.json({ recipes: recipeList });
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
                let recipeList = user.favorites;

                for (var i = 0; i < recipeList.length; i++) {
                    recipeList[i] = { _id: recipeList[i] }
                }

                if (recipeList.length != 0) {
                    // Do it in one query this way, unsure if this is computationally efficient
                    recipeList = await Recipe.find({ $or: recipeList }, '-__v');
                }

                res.json({ recipes: recipeList });
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
    use: use
};