describe("Construct Path", function() {
    const ConstructPath = require('../../routes/lib/constructpath');

    // Create test pathRoot and path variables
    var pathRoot, path, construct;

    it("should return the sum of the pathRoot and the path", function() {
        //i dont think this is the right way to call this function lol
        //construct = ConstructPath.function(pathRoot, path);

        // We expect the return value to equal pathRoot + path
        expect(construct).toBeEqual(pathRoot + path);
    });
});