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

    if (!('name' in event)) {
        throw new Error('Name not found.');
    }
    if (event['name'].length < 1) {
        throw new Error('Name is invalid.');
    }

    if (!('commission' in event)) {
        throw new Error('commission not found.');
    }
    if (event['commission'].length < 1) {
        throw new Error('commission is invalid.');
    }

    var result;
    try {
        [result] = await connection.query('INSERT INTO publishers SET name = ?, commission= ?', [event['name'],event['commission']]);
        console.log(result);
        return {'id': result.insertId};
    } catch(err) {
        console.log(err);
        throw new Error('Database query error');
    }
}