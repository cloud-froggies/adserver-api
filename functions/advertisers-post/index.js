var mysql = require('mysql2/promise');

var connection;

exports.handler = async (event) => {
    if (typeof connection === 'undefined') {
        connection = await mysql.createConnection({
            host: 'froggy-db.cc9gjm0rmktt.us-east-2.rds.amazonaws.com',
            user: 'admin',
            password: 'L0stNexus6',
            database: 'configuration'
        });
        
        console.log("connection stablished")

    }
    
    try {
        var response = await connection.query(`INSERT INTO advertisers(name) VALUES('${event.name}')`);
		console.log(response);
    }
    catch (err) {
        console.log(err);
        throw new Error(err);
    }


}
