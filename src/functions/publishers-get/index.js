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
            throw new Error('Database connection error');
        }
    }

    var rows;
    var fields;
    try {
        [rows, fields] = await connection.query('SELECT id,name FROM publishers');
    }
    catch(err) {
        console.log(err);
        throw new Error('Database query error');
    }
    if (rows.length > 0)
        return rows;
    else
        throw new Error('No publishers');
}