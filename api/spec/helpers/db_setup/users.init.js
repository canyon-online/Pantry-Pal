// Check the database to ensure that it is set up for Users
const User = require('../../../models/user');

// This userId is used in various unit tests
const userId = "6057ea36feb239464ca2f076";

// Define a nice user to use
const niceUser = {
    google: false,
    verified: true,
    display: "Test User"
}

// Use upsert to create a user with this id
User.findByIdAndUpdate(userId, niceUser, {
    new: true,
    upsert: true
}).exec();

// Export the userId we create so tests can use them
module.exports.userId = userId;