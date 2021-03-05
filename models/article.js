const mongoose = require('mongoose');

// A database schema is it's structure. The mongoose schema is a prototype that
// maps to a MongoDB collection and defines the shape of the documents within that
// collection. Here we are creating an instance of mongoose.Schema that defines two
// fields with type set to String and making them required. Read about Mongoose Schema
// at mongoosejs.com/docs/guide.html.
const articleSchema = new mongoose.Schema({ 
    title: {
        type: String,
        required: [true, "Title is required"]
    },
    content: {
        type: String,
        required: [true, "Content can't be blank"]
    }
});

// Models represent the data in an application. A mongoose model is a constructor
// function that creates and reads documents to and from the underlying MongoDB database.
// The first argument is the singular uppercase name of your database collection.
// So Article represents the articles MongoDB collection. The second argument is
// the schema which we defined above. An individual article is an instance of the Article model.
module.exports = mongoose.model('Article', articleSchema); 
