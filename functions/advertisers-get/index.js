var mysql = require('mysql2/promise');

var connection;

exports.handler = async (event) => {
    if (typeof connection === 'undefined') {
        connection = await mysql.createConnection({
            host: 'host.rds.amazonaws.com',
            user: 'user',
            password: 'password',
            database: 'configuration'
        });
    }

    try {
        var response = await connection.query('SELECT * FROM advertisers');
		console.log(response);
    }
    catch (err) {
        console.log(err);
        throw new Error(err);
    }


}