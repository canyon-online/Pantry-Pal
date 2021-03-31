// The maximum number of records allowed to be returned in one request
const maxRecords = process.env.MAX_RECORD_RETURNS || 50;

// Function to check the validity of an ObjectId passed
const validateObjectId = require('./validateObjectId');

// Robust searching for varying Mongoose models
async function search(model, req) {
    var query;

    // Based on query parameters, construct the query
    query = model.find({});

    for (var param in req.query) {
        // Ensure that this is a searchable field
        if (!model.schema.obj[param])
            continue;

        // Ensure that there is even content in the query
        if (!req.query[param])
            continue;

        // Currently only support querying string, numbers, and ObjectIds
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
        } else if (param == 'tags' &&  model.schema.obj[param]) {
            // Handle tags searches for recipes
            const tags = req.query[param].split(",");
            if (tags[0] != '')
                query.where(param, { $all: tags });
        } else if (param == 'ingredients' && model.schema.obj[param]) {
            // Handle ingredient searches for recipes
            let ingredients = req.query[param].split(",");
            let validIngredientsList = [];
            let validIngredientsOr = [];
            // Ensure only valid strings that can be cast to ObjectIds are passed
            for (var i = 0; i < ingredients.length; i++)
            {
                if (validateObjectId(ingredients[i])) {
                    validIngredientsList.push(ingredients[i]);
                    validIngredientsOr.push({ ingredients: ingredients[i] });
                }
            }
            if (ingredients[0] == 'any') {
                if (validIngredientsOr.length != 0)
                    query.where('$or', validIngredientsOr);
            }
            else {
                if (validIngredientsList.length != 0)
                    query.where(param, { $all: validIngredientsList });
            }
        } else {
            continue;
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