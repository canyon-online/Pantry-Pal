// The Google Auth Library is required to validate any tokens we recieve
// The client_id should be filled in by an environmental variable
// https://www.npmjs.com/package/google-auth-library
// Decent tutorial on the topic (up to managing a user session): 
// https://blog.prototypr.io/how-to-build-google-login-into-a-react-app-and-node-express-api-821d049ee670
const { OAuth2Client } = require('google-auth-library');
const googleClient = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

// Given a token returns a ticket object that contains a payload
// The payload contents will depend on the scope defined in the oAuth credentials
// https://googleapis.dev/nodejs/google-auth-library/5.5.0/classes/LoginTicket.html
async function getTicket(token)
{
    const ticket = await googleClient.verifyIdToken({
        idToken: token,
        audience: process.env.GOOGLE_CLIENT_ID
    });

    return ticket;
}

// Export pertinent functions and objects related to Google oAuth
module.exports = {
    googleClient: googleClient,
    getTicket: getTicket,
};