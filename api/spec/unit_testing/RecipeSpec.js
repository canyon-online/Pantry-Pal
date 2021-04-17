describe("Recipe", function() {
    var Recipe = require('../../routes/recipes');

    const RecipeVals = {
        recipes: recipes,
        userId: "userId"
    }

    var token;

    it("should populate the recipe list", function() {
        // Populate the recipe list
        token = Recipe.populateRecipes(RecipeVals.recipes, RecipeVals.userId);

        // We expect the recipe list fields to be populated
    });

});