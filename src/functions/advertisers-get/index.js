var mysql = require('mysql2/promise');

var connection;

exports.handler = async (event) => {
    console.log(event);
    if (typeof connection === 'undefined') {
        try {
            connection = await mysql.createConnection({
                host: process.env.db_endpoint,
                user: process.env.db_admin_user,
                password: process.env.db_admin_password,
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