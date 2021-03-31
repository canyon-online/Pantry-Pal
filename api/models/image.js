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
        required: [true, "Image name is required"],
    },
    dateCreated: {
        type: Date,
        default: Date.now
    },
    discLocation: {
        type: String,
        // Validate the disc location on production so automated clean-up does not cause catastrophe
        validate: {
            validator: function(v) {
                // We do not care about assuring this on non-production machines
                if (process.env.IS_PRODUCTION != 1)
                    return true;

                return new RegExp(`${process.env.UPLOADS_DIRECTORY}/[A-Za-z0-9]*.png$`).test(v);
            },
            message: props => `${props.value} is not a valid disc location, not adding to the database -- too risky`
        },
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
