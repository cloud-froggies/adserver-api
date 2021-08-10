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
            throw new Error(JSON.stringify({'status': 500, 'messages': ['Database connection error']}));
        }
    }

    if (!('name' in event)) {
        throw new Error(JSON.stringify({'status': 400, 'messages': ['Name not found.']}));
    }
    if (event['name'].length < 1) {
        throw new Error(JSON.stringify({'status': 400, 'messages': ['Name is invalid.']}));
    }

    var result;
    try {
        [result] = await connection.query('INSERT INTO advertisers SET name = ?', [event['name']]);
        console.log(result);
        return {'status': 200, 'response': {'id': result.insertId}};
    } catch(err) {
        console.log(err);
        throw new Error(JSON.stringify({'status': 500, 'messages': ['Database query error']}));
    }
}