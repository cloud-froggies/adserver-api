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
    responseObject['response'] = body

    return responseObject




# Handler
def lambda_handler(event, context):
    # 400 bad request
    class BadRequestException(Exception):
        pass
    # 404 not found
    class NotFoundException(Exception):
        pass

    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        advertiser_id = event['queryStringParameters']['advertiser-id']
        query = "SELECT * FROM advertisers WHERE id = {};".format(advertiser_id)
        cursor.execute(query)
        
    if not (results := cursor.fetchone()):
        raise NotFoundException('No existe el advertiser.')

    try:
        name = event['body']['name']
        category = event['body']['category']
        advertiser_id =  event['queryStringParameters']['advertiser-id']
        cursor = conn.cursor()
        query = "INSERT INTO advertiser_campaigns (advertiser_id ,name, category, bid, status, budget) VALUES ({},'{}', {}, 0, 0, -1);".format(advertiser_id ,name, category)
        cursor.execute(query)
        insert_id = conn.insert_id()
        conn.commit()
        return success_response({'id': insert_id})
    except:
        raise BadRequestException('Sin nombre o vacío.')