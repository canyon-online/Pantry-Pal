// "Fake" Express response object for use in our unit tests
function Response() {
    this.statusCode = 200;
}

Response.prototype.json = function(jsonObject) {
    this.body = jsonObject;

    return this;
}

Response.prototype.status = function(statusCode) {
    this.statusCode = statusCode;

    return this;
}


module.exports = Response;