// Error logging as well as general HTTP logging
// Varying verbosity levels
const winston = require('winston');
const expressWinston = require('express-winston');

// Get the log configuration from the environment
const logDir = process.env.LOG_DIRECTORY || 'logs';
const logSize = process.env.LOG_MAX_SIZE || 1E7; // 10 MB

// Initialize error logging for the passed Express object
// Note: This should be done after any routers are added so it captures their errors
exports.errorLogging = (app) => {
    app.use(expressWinston.errorLogger({
        transports: [
            new winston.transports.Console(), // Log to the console
            new winston.transports.File({
                name: 'error-file',
                filename: `${logDir}/error.log`,
                maxsize: logSize,
                zippedArchive: true
            })
        ],
        format: winston.format.json(),
        meta: true,
        colorize: false
    }));
}

// Initialize http traffic logging for the passed Express object
// Note: This should be done before any routers are added
exports.httpLogging = (app) => {
    app.use(expressWinston.logger({
        transports: [
            new winston.transports.File({
                name: 'http-file',
                filename: `${logDir}/access.log`,
                maxsize: logSize,
                zippedArchive: true
            })
        ],
        format: winston.format.json(),
        meta: true,
        colorize: false
    }));
}