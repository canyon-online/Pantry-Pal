describe("Construct Path", function() {
    const ConstructPath = require('../../routes/lib/constructpath');

    // Create test pathRoot and path constants
    const pathRoot = "/var";
    const path = "/www";
    const concatPath = "/var/www";

    // Create test construct variable
    var construct;

    it("should return the sum of the pathRoot and the path", function() {
        construct = ConstructPath(pathRoot, path);

        // We expect the return value to equal pathRoot + path
        expect(construct).toEqual(concatPath);
    });
});