// Enabling of environmental variables can be done by uncommenting the following line
// require('dotenv').config()

// Configure mongoose to use a local testing database
const mongoose = require('mongoose');
const MONGO_HOST = process.env.DB_HOST || 'localhost';
const MONGO_PORT = process.env.DB_PORT || 27017;
const MONGO_DB = process.env.DB_NAME || 'testDB';
const MONGO_URI = `mongodb://${MONGO_HOST}:${MONGO_PORT}/${MONGO_DB}`;

mongoose.connect(MONGO_URI, { 
  useNewUrlParser: true,
  useFindAndModify: false,
  useUnifiedTopology: true,
  useCreateIndex: true
});