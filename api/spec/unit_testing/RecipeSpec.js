describe("Recipes", function() {
    // :')
    const Recipe = require('../../models/recipe');
    const Recipes = require('../../routes/recipes');

    // Import the user and ingredient initialization so we have the ids
    const IngInit = require('../helpers/db_setup/ingredients.init');
    const UInit = require('../helpers/db_setup/users.init');

    var recipe;

    // Recipe template object (should pass validation)
    const recipeVals = {
        name: "Long Name",
        directions: "Directions",
        image: "",
        author: UInit.userId, // "magic" id that is created with init scripts
        ingredients: [IngInit.ingredientId],
    };

    it("should populate the recipe list for an unautheticated user", async function() {
        // Generate a recipe, but we do not have to save it
        recipe = new Recipe(recipeVals);

        // Populate the recipe
        var recipes = await Recipes.populateRecipes([recipe]);

        // Expect our recipe to be populated (have filled-in author and ingredient fields)
        expect(recipes[0].author._id).toBeDefined();
        expect(recipes[0].ingredients[0]._id).toBeDefined();
    });

    it("should populate the recipe list for an autheticated user", async function() {
        // Generate a recipe, but we do not have to save it
        recipe = new Recipe(recipeVals);

        // Populate the recipe
        var recipes = await Recipes.populateRecipes([recipe], recipeVals.author);

        // Expect our recipe to be populated (have filled-in author and ingredient fields)
        expect(recipes[0].author._id).toBeDefined();
        expect(recipes[0].ingredients[0]._id).toBeDefined();

        // Expect the autheenticated user's isLiked to be a member
        // We also expect it to be false, as this recipe does not truly exist
        expect(recipes[0].get("isLiked")).toEqual(false);
    }); 

});