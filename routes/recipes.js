// Import libraries for handling database operations
const jwt = require('./lib/jwtUtils');
const mongoose = require('mongoose');

// Import the relevant models
const User = require('../models/user'); 
const Recipe = require('../models/recipe'); 

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/recipes
const endpointPath = '/recipes';

// The maximum number of records allowed to be returned in one request
const maxRecords = process.env.MAX_RECORD_RETURNS || 50;

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
        var query;

        // Based on query parameters, construct the query
        query = Recipe.find({});

        for (var param in req.query) {
            // Ensure that this is a searchable field
            if (!Recipe.schema.obj[param])
                continue;

            // Currently only support querying string and integer types
            if (Recipe.schema.obj[param].type != String && Recipe.schema.obj[param].type != Number)
                continue;

            query.where(param, new RegExp(`${req.query[param]}`, "i"));
            // Semantically equivalent to query.where(param, { $regex: `.*${req.query[param]}.*`} );
        }

        // Actually execute query, ensuring it only returns pertinent fields
        query.limit(req.query.limit ? (parseInt(req.query.limit) > maxRecords ? maxRecords : parseInt(req.query.limit)) : maxRecords);
        // todo: handle sorting field and direction
        query.sort({numHits: "asc"});

        let foundRecipes = await query.exec();

        // Estimate the total amount of recipes that would be found before limiting
        const totalRecipes = await query.count();

        // Now we want to reveal some user information for each record found
        foundRecipes = await getUsersForRecipes(foundRecipes);

        res.json({ totalRecords: totalRecipes, filteredRecords: foundRecipes.length, recipes: foundRecipes });
    });
}

// Export the login object containing the use function
module.exports = {
    use: use
};