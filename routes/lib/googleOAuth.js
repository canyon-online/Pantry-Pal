// Import our JWT library for use in generating tokens
const jwt = require('./jwtUtils');

// Import our User model
const User = require('../../models/user'); 

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
        idToken: token
    });

    return ticket;
}

// Validation function for local registration request bodies
// Checks existence of and authenticity of the token passed
async function verifyGoogle(body, res)
{
    if (!body) {
        res.status(400).json({ error: "No body included in request" });
        return { isValid: false };
    }

    if (!body.token) {
        res.status(422).json({ error: "No OAuth token included in request" });
        return { isValid: false };
    }

    const ticket = await getTicket(body.token).catch(function(err) {
        res.status(422).json({ error: "Failed to validate authenticity of OAuth token" });
    });

    if (!ticket)
        return { isValid: false };

    return { isValid: true, ticket: ticket };
}

// Google registration function that attempts to add a user to the database
// Takes a Google Login Ticket and generates a user from it
async function registerGoogle(res, ticket)
{
    const { name, email, picture } = ticket.getPayload();

    if (!name || !email || !picture)
    {
        res.status(422).json({ error: "Failed to extract data from Google Login Ticket" });
        return;
    }

    // Attempt to save registered user
    let user = new User({
        display: name,
        email: email,
        avatar: picture,
        google: true
    });

    user.save()
    .then(async user => {
        // Successfully created the new user, now use it to log in
        await jwt.sendJWT(user, res);
    })
    .catch(async function(err) {
        // If this error occured for Google login, it is most likely a duplicate email
        // Forward this registration attempt to login as it can be a simple mistake
        // to press the register w/ Google button vs the login w/ Google button
        await loginGoogle(res, ticket);
    });
}

// Google login function that attempts to log a Google user in
// Takes a Google Login Ticket and extracts user info from it, which is then used to
// generate a JWT
// If the user does not exist, the registration function will be called
async function loginGoogle(res, ticket)
{
    const { name, email, picture } = ticket.getPayload();

    if (!name || !email || !picture)
    {
        res.status(422).json({ error: "Failed to extract data from Google Login Ticket" });
        return;
    }

    let user = User.findOne({ email: email }).exec();

    // If no user is found, then we should register them
    if (user == null) {
        await registerGoogle(res, ticket);
    }
    else
    {
        // No error, so we can generate and send a JWT
        await jwt.sendJWT(user, res);
    }
}

// Export pertinent functions and objects related to Google oAuth
module.exports = {
    googleClient: googleClient,
    getTicket: getTicket,
    loginGoogle: loginGoogle,
    registerGoogle: registerGoogle,
    verifyGoogle: verifyGoogle
};