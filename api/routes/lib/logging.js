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
                filename: `${logDir}/express-error.log`,
                maxsize: logSize
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
                maxsize: logSize
            })
        ],
        format: winston.format.json(),
        meta: true,
        colorize: false
    }));
}

// Create logging action for custom logged actions
// This is to be used whenever we do a loggable action, such as sending an email
exports.genericLogger = winston.createLogger({
    level: 'info',
    format: winston.format.json(),
    transports: [
        new winston.transports.File({
            filename: `${logDir}/events.log`,
            maxsize: logSize
        }),
        new winston.transports.File({
            filename: `${logDir}/error.log`,
            level: 'error',
            maxsize: logSize
        }),
        new winston.transports.Console()
    ]
});