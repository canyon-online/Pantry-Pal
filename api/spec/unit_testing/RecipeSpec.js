describe("Recipes", function() {
    // :')
    const Recipe = require('../../models/recipe');
    const Recipes = require('../../routes/recipes');

    var recipe;

    // Recipe template object (should pass validation)
    const recipeVals = {
        name: "Long Name",
        directions: "Directions",
        image: "",
        author: "6057ea36feb239464ca2f076", // atm these are kind of magic numbers, really need to make a helper for this probably
        ingredients: ["6063ede90cafeb2ca0abc729"],
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