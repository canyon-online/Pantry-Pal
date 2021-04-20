describe("JWT library", function() {
    // Our "wrapper" library we are testing
    var JWTLib = require('../../routes/lib/jwtUtils');
    
    // Constant testing values we will use for testing JWTS
    const JWTVals = {
        algorithm: "HS256",
        typ: "JWT",
        userId: "userId",
        name: "name",
        verified: "verified"
    }

    // Create a token, so we can use the verification functions after successfully generating one
    var token;

    it("should generate and sign a JWT", function() {
        // Generate a JWT using the three parameters
        // Using example strings such as "userId" rather than actual ObjectIds, as it should not matter
        token = JWTLib.generateJWT(JWTVals.userId, JWTVals.name, JWTVals.verified);

        // We expect there to be three parts of a JWT, all base64 encoded
        // The encryption algorithm, the payload ({ userId, name, verified }), and the payload hashed
        // We can verify the first two parts here
        expect(token).toHaveAlgorithm(JWTVals.algorithm);
        expect(token).toHavePayload({ userId: JWTVals.userId, name: JWTVals.name, verified: JWTVals.verified });
    });

});