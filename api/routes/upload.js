// Library for handling file uploads and cryptography
const crypto = require('crypto');
const jwt = require('./lib/jwtUtils');
const mongoose = require('mongoose');
const multer = require('multer');

// Import the image model
const Image = require('../models/image');

// Control the disk storage and upload filenames
const uploadDir = process.env.UPLOADS_DIRECTORY || 'uploads/';
const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, uploadDir);
    },
    filename: function(req, file, cb) {
        // Save all images as ending in .png for current simplicity
        // Generate a sha1 hash of the file name and the current date so there are no collisions with filenames
        const suffix = '.png';
        let fileName = crypto.createHash('sha1').update(`${file.originalname}-${Date.now() + Math.random()}`).digest('hex');
        cb(null, `${fileName}${suffix}`);
    }
});

// Create the upload object
const upload = multer({ 
    storage: storage,
    limits: {
        fileSize: process.env.MAX_UPLOAD_SIZE || 1E7 // 10MB default, should probably lower it
    },
    fileFilter: function (req, file, cb) {
        // Ensure the file is actually an image
        if (!allowedTypes[file.mimetype]) {
            req.fileValidationError = 'mimetype';
            cb(null, false);
        }
        else
            cb(null, true);
    }
 });
const imageUpload = upload.single('image');

 // Allowed image mimetypes
const allowedTypes = {
    'image/bmp': true,
    'image/gif': true,
    'image/jpeg': true,
    'image/png': true,
    // 'image/svg+xml': true // fairly certain svgs can easily have malicious code embedded
    'image/tiff': true,
    'image/webp': true
}

// The root path of this endpoint, which is concatenated to the router path
// In the current version, this is /api/upload
const constructPath = require('./lib/constructpath');
const endpointPath = '/upload';

// TODO: make this actually secure (e.g. logging a lot of information, read/write perms, etc.)
// Uploading is always an authenticated action
function authenticatedActions(router) {
    // POST /, attempts a file upload, then returns a URL if successful
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        imageUpload(req, res, function(error) {
            if (error) {
                if (error instanceof multer.MulterError) {
                    switch (error.code) {
                        case 'LIMIT_FILE_SIZE':
                            res.status(413).json({ error: `File too large (Max ${(process.env.MAX_UPLOAD_SIZE || 1E7) / 1E6} MB)` });
                            break;
                        
                        default:
                            res.status(400).json({ error: error.message });
                    }
                } else if (err) {
                    res.status(500).json({ error: "Unknown error has occurred during file upload" });
                }
                
                // If any upload errors occur do not attempt to create an Image
                return;
            }

            // Invalid file type
            if (req.fileValidationError) {
                // This response is hard-coded for now, but could be made to dynamically print the 'allowed' list
                res.status(422).json({ error: "File is not a supported image (Allowed: bmp, gif, jpg, png, tiff, webp)" })
                return;
            }

            // No file uploaded
            if (!req.file) {
                res.status(422).json({ error: "Missing file from request" });
                return;
            }

            // Get the userid from the JWT (can assume that there is a valid token)
            const token = req.headers.authorization.split(' ')[1];
            const { userId } = jwt.verifyJWT(token);

            // Upload was successful, store this in the database and return the relative url
            const image = new Image({
                author: mongoose.Types.ObjectId(userId),
                fileName: req.file.filename,
                discLocation: `${uploadDir}/${req.file.filename}`,
                uriLocation: `/images/${req.file.filename}`
            });

            image.save().then(function(img) {
                res.json({ image: `/images/${req.file.filename}` });
            }).catch(function(error) {
                res.json({ error: error });
            });
        });
    });
}


function use(router, authenticatedRouter) {
    // Assign the routers to be used
    authenticatedActions(authenticatedRouter); 
}

// Export the use function, enabling the upload endpoint
module.exports = {
    use: use
};