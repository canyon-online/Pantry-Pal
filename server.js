// Start by importing our express and mongoose packages and our Express router which we'll define shortly.
const express = require('express'); 
const mongoose = require('mongoose');

// To allow cross origin access uncomment the cors lines.
// const cors = require('cors');

const router = require('./routes/index');

// Load the process environmental variables, located in a .dotenv file
require('dotenv').config()

// Calling the express() function will create our running app object.
const app = express(); 

// The Express listen method called at the bottom of our file uses 3000 as it's 
// default port for it's server. We'll declare a new PORT constant to give us 
// the flexibility to use different ports depending on whether we are in development or production.
const PORT = process.env.PORT;

// Assigning constants for things like port number and the database URL gives us
// the flexibility to change the values in one place.
// If you are using the MongoDB Atlas cloud database then paste the link there.
// If you are using the local version, MongoDB is accessed through localhost on port 27017 by default, 
// and the path is the database name. We'll just call ours my_local_db.
const MONGODB_URI = "mongodb://localhost:27017/my_local_db";

// app.use(cors())

// Chaining Express's use method to our app object gives us access to the libraries
// we imported. express.urlencoded({ extended: true }) and express.json() are middleware
// for parsing requests with JSON payloads (for POST and PATCH/PUT requests).
app.use(express.urlencoded({ extended: true }));
app.use(express.json());

// Apply the Express router object to your Express app. I'll explain this in the routing section.
app.use('/api', router);

// mongoose.connect() connects to our MongoDB database
mongoose.connect(MONGODB_URI, { useNewUrlParser: true, useFindAndModify: false, useUnifiedTopology: true });

// Optionally, log a message if the above connection was successful and one if it is not.
mongoose.connection.once('open', function() {
    console.log('Connected to the Database.');
});

mongoose.connection.on('error', function(error) {
    console.log('Mongoose Connection Error : ' + error);
});

// Chain the Express listen method to our app. This will listen for connections on the specified port.
// Also check for the environmental variables, so we know whether or not we are going to be serving https
if (process.env.SSL == 1) {

    const https = require('https');
    const fs = require('fs');
    const httpsServer = https.createServer({
        key: fs.readFileSync(process.env.CERT_KEY_LOCATION),
        cert: fs.readFileSync(process.env.CERT_LOCATION)
    }, app);
    
    httpsSevver.listen(PORT, function() {
        console.log(`Server listening on port ${PORT}.`);
    })

} else {
    app.listen(PORT, function() {
        console.log(`Server listening on port ${PORT}.`);
    });
}