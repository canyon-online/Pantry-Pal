// Keep ObjectId validity checks consistent across files
const OIDLength = process.env.OBJECTID_LENGTH || 24;

module.exports = function(input) {
    return input.length == OIDLength;
}