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

        // Modify the query to remove irrelevant fields from results
        query.select(['-__v', '-image']);

        await query.exec(async function(err, ingredients) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Now we want to reveal the user display name for each record found
            // Perhaps not good to mutate the input like done here?
            ingredients = await getUsersForIngredients(ingredients);

            // No error in query execution, so respond with typical search output
            res.json({ totalRecords: totalRecords, filteredRecords: ingredients.length, ingredients: ingredients });
        });
    });

    // GET /:id, returns the ingredient indicated by the id
    router.get(constructPath(endpointPath, '/:id'), async function(req, res) {
        var foundIngredient;

        // Attempt to form an object id from the input
        try{
            mongoose.Types.ObjectId(req.params.id);
        } catch(err) {
            //Not a valid id, so tell the user
            res.status(422).json({ error: "The provided id is not a valid id" });
            return;
        }

        // Attempt to retrive the ingredient
        Ingredient.findById(req.params.id, async function(err, ingredient) {
            if (err) {
                res.status(422).json({ error: "Failed to execute query" });
                return;
            }

            // Id does not point to an existing ingredient
            if (!ingredient) {
                res.status(404).json({ error: "There is no ingredient with that id" });
                return;
            }

            // Now we want to reveal some user information for the ingredient found
            // We transform the ingredient into a list temporarily so this function works for it
            ingredient = await getUsersForIngredients([ingredient]);

            res.json(ingredient[0]);
        });
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

    // PATCH /:id, modifies ingredient fields by id
    router.patch(constructPath(endpointPath, '/:id'), async function(req, res) {
        // Attempt to update ingredient
        Ingredient.findByIdAndUpdate(req.params.id, req.body)
        .then(function() {
            res.json('Ingredient updated');
        })
        .catch(function() {
            res.status(422).send("Ingredient update failed.");
        });
    });

    // DELETE /:id, deletes an ingredient by id
    router.delete(constructPath(endpointPath, '/:id'), async function(req, res) {
        // Attempt to delete ingredient
        Ingredient.findById(req.params.id, async function(err, ingredient) {
            if (!ingredient) {
                res.status(404).send('Ingredient not found');
            } else {
                Ingredient.findByIdAndRemove(req.params.id)
                .then(function() {res.status(200).json("Article deleted") })
                .catch(function(err) {
                    res.status(400).send("Article delete failed.");
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

// Export the use function, enabling the ingredients endpoint
module.exports = {
    use: use
};