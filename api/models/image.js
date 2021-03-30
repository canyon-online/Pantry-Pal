const mongoose = require('mongoose');

// Schema used to keep track of downloaded images, where they are, and whether or not they are used
// Every now and then, we can go through and delete images that are unused and are old
const imageSchema = new mongoose.Schema({ 
    author: {
        // Keep track of API abuse
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User'
    },
    fileName: {
        type: String,
        required: [true, "Ingredient name is required"],
    },
    dateCreated: {
        type: Date,
        default: Date.now
    },
    discLocation: {
        type: String,
        required: [true, "Disc location is required"]
    },
    uriLocation: {
        type: String,
        required: [true, "Relative location is required"]
    },
    unused: {
        type: Boolean,
        default: true
    }
});

module.exports = mongoose.model('Image', imageSchema); 
