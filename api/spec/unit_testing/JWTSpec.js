describe("JWT library", function() {
    // Our "wrapper" library we are testing
    var JWTLib = require('../../routes/lib/jwtUtils');
    var userSchema = require('../../models/user');
    const Response = require('../test_models/res');

    // Test response and user objects
    var res, user;
    
    // Constant testing values we will use for testing JWTS
    const JWTVals = {
        algorithm: "HS256",
        typ: "JWT",
        userId: "userId",
        name: "name",
        verified: "verified",
        email: "gmail@gmail.com"
    }

    // Create a new Express response object for testing
    beforeEach(function() {
        res = new Response();
        user = new userSchema({ _id: JWTVals.userId, display: JWTVals.name, verified: JWTVals.verified, email: JWTVals.email});
    });

    // Create a token, so we can use the verification functions after successfully generating one
    var token, nullToken = null, verify;

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

    it("should verify a JWT and return the token payload", function() {
        // Store the return value of the verifyJWT function
        verify = JWTLib.verifyJWT(token);

        // We expect the payload to be returned
        expect(verify.userId).toEqual(JWTVals.userId);
    });

    it("should verify a JWT and return null", function() {
        // Store the return value of the verifyJWT function
        verify = JWTLib.verifyJWT(nullToken);

        // We expect the return value to be null
        expect(verify).toBeNull();
    });
});
