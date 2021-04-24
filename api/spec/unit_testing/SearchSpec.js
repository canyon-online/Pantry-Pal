describe("Search", function() {
    const Search = require('../../routes/lib/search');
    const Recipe = require('../../models/recipe');

    // Create a test request object
    const req = {
        query: "query"
    }

    // Create a variable to store the return value of the search function
    var token;

    it("should search various models", function() {
        // Search the recipe model and save the return value
        token = Search.search(Recipe, req);

        // We expect the query to not be null
        expect(token).toNotEqual(null);
    });
});
