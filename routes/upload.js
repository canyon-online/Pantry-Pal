// Library for handling file uploads and cryptography
const multer = require('multer');
const crypto = require('crypto');

// Control the disk storage and upload filenames
const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, process.env.UPLOADS_DIRECTORY || 'uploads/');
    },
    filename: function(req, file, cb) {
        // For now, save all images as ending in .png
        // Generate a sha1 hash of the file name and the current date so there are no collisions
        // TODO: figure out what formats are ideal for frontend
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
const endpointPath = '/upload';

// Function to concatenate paths
function constructPath(pathRoot, path) {
    return pathRoot + path;
}

// TODO: make this actually secure (e.g. logging a lot of information, read/write perms, etc.)
function use(router) {
    // This endpoint is authenticated actions
    // POST /, attempts a file upload, then returns a URL if successful
    router.post(constructPath(endpointPath, '/'), async function(req, res) { 
        imageUpload(req, res, function(err) {
            if (err) {
                console.log(err);
                // Basic error handling for now. TODO: Add responses for all types of multerErrors
                res.status(413).json({ error: `File too large (Max ${(process.env.MAX_UPLOAD_SIZE || 1E7) / 1E6} MB)`});
                return;
            }

            // Invalid file type
            if (req.fileValidationError) {
                // This response is hard-coded for now, but could be made to dynamically print the 'allowed' list
                res.status(422).json({ error: "File is not a supported image (Allowed: bmp, gif, jpg, png, tiff, webp)"})
                return;
            }

            // No file uploaded
            if (!req.file) {
                res.status(422).json({ error: "Missing file from request" });
                return;
            }

            // Upload was successful, return the url
            res.json({ image: `/images/${req.file.filename}` });
        });
    });
}

// Export the use function, enabling the upload endpoint
module.exports = {
    use: use
};