// Import libraries for handling database operations
const jwt = require('./lib/jwtUtils');
const mongoose = require('mongoose');
const search = require('./lib/search');

// Import the relevant models
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/recipes
const constructPath = require('./lib/constructpath');
const endpointPath = '/users';

// Assumed a user is logged in to access any of these endpoints
// Any user endpoint should be authenticated to help prevent abuse
function authenticatedActions(router) {
    // GET /, returns list of recipes matching given query parameters
    router.get(constructPath(endpointPath, '/'), async function(req, res) {
        // Strip the search fields of any risky search parameters
        // TODO: make this a library function to strip request parameters
        req.query.password = null;
        req.query.google = null;
        req.query.verified = null;
        req.query.email = null;
        req.query.sortBy = null;

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
}

function use(router, authenticatedRouter) {
    // Assign the routers to be used
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the users endpoint
module.exports = {
    use: use
};