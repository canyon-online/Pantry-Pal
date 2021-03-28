// The maximum number of records allowed to be returned in one request
const maxRecords = process.env.MAX_RECORD_RETURNS || 50;

// Robust searching for varying Mongoose models
async function search(model, req) {
    var query;

    // Based on query parameters, construct the query
    query = model.find({});

    for (var param in req.query) {
        // Ensure that this is a searchable field
        if (!model.schema.obj[param])
            continue;

        // Currently only support querying string and number types
        if (model.schema.obj[param].type != String && model.schema.obj[param].type != Number)
            continue;

        if (model.schema.obj[param].type == String)
            query.where(param, new RegExp(`${req.query[param]}`, "i"));
        else if (model.schema.obj[param].type == Number) {
            // Supporting gt, gte, lt, and lte comparisons
            const extractedNumber = req.query[param].match(/\d+/)[0];

            if (req.query[param].charAt(0) == ">") {
                if (req.query[param].charAt(1) == "=")
                    query.where(param).gte(parseInt(extractedNumber));
                else
                    query.where(param).gt(parseInt(extractedNumber));
            } else if (req.query[param].charAt(0) == "<") {
                if (req.query[param].charAt(1) == "=")
                    query.where(param).lte(parseInt(extractedNumber));
                else
                    query.where(param).lt(parseInt(extractedNumber));
            } else {
                continue;
            }
        }
    }

    // Estimate the total amount of a model that would be found before limiting
    const countQuery = query.model.find().merge(query);
    const totalRecords = await countQuery.countDocuments();

    // Actually execute query, ensuring it only returns pertinent fields
    const limit = req.query.limit ? (parseInt(req.query.limit) > maxRecords ? maxRecords : parseInt(req.query.limit)) : maxRecords;
    const offset = req.query.offset || 0;
    query.skip(offset * limit);
    query.limit(limit);

    // Allow different methods of sorting
    const sortBy = req.query.sortBy;
    if (sortBy) {
        if (model.schema.obj[sortBy].type == Number) {
            const direction = req.query.direction || -1;

            // Ensure that the direction is a valid one (1 and -1 for asc/desc)
            if (direction != 1 && direction != -1)
                direction = -1;

            query.sort(`${direction == 1 ? '' : '-'}${sortBy}`);
        }
        else {
            query.sort({_id: -1}); // default case
        }
    } else {
        query.sort({_id: -1}); // default case
    }

    return { totalRecords: totalRecords, query: query };
}
        
module.exports = search;