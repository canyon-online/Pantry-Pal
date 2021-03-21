// The Google Auth Library is required to validate any tokens we recieve
// The client_id should be filled in by an environmental variable
// https://www.npmjs.com/package/google-auth-library
// Decent tutorial on the topic (up to managing a user session): 
// https://blog.prototypr.io/how-to-build-google-login-into-a-react-app-and-node-express-api-821d049ee670
const { OAuth2Client } = require('google-auth-library');
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);


// Export pertinent functions and objects related to Google oAuth
exports = {
    googleClient: googleClient
};