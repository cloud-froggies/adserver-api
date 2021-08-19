import pymysql
import os
import json
import sys
import logging


logger = logging.getLogger()
logger.setLevel(logging.INFO)


# Configuration Values
endpoint = os.environ['db_endpoint']
username = os.environ['db_admin_user']
password = os.environ['db_admin_password']
db_name = "configuration"


# Connection
try:
    conn = pymysql.connect(host=endpoint, user=username, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


# Responses
def success_response(body):
    responseObject = {}
    responseObject['statusCode'] = 200
    responseObject['headers'] = {}
    responseObject['headers']['Content-Type'] = 'application/json'
    responseObject['body'] = json.dumps(body)

    return responseObject


# Handler
def lambda_handler(event, context):
    # Parse out query string params/payload body
    id = event['queryStringParameters']['advertiser-id']
    
    with conn.cursor() as cursor:
        query = "SELECT * FROM advertisers WHERE id = {};".format(id)
        cursor.execute(query)
        
    if cursor.rowcount > 0:
        body = cursor.fetchall()
        return success_response(body)
    else:
        raise Exception('No existe el advertiser.')
    