var mysql = require('mysql2/promise');

var connection;

exports.handler = async (event) => {
    console.log(event);
    if (typeof connection === 'undefined') {
        try {
            connection = await mysql.createConnection({
                host: 'froggy-db.cc9gjm0rmktt.us-east-2.rds.amazonaws.com',
                user: 'admin',
                password: 'L0stNexus6',
                database: 'configuration'
            });    
        }
        catch(err) {
            console.log(err);
            throw new Error(JSON.stringify({"status": 500, "messages": ['Database connection error']}));
        }
    }

    var rows;
    var fields;
    try {
        [rows, fields] = await connection.query('SELECT * FROM advertisers');
    }
    catch(err) {
        console.log(err);
        throw new Error(JSON.stringify({"status": 500, "messages": ['Database query error']}));
    }
    if (rows.length > 0)
        return {"status": 200, "response": rows};
    else
        throw new Error(JSON.stringify({"status": 404, "messages": ['No advertisers']}));
}