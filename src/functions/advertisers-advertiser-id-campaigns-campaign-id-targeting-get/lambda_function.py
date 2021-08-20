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
    zips = []
    for row in body:
        zips.append(row[0])
    responseObject['response'] = {'zip-codes': zips}
    return responseObject


# Handler
def lambda_handler(event, context):
    # Connection
    try:
        conn = pymysql.connect(host=endpoint, user=username, passwd=password, db=db_name, connect_timeout=5)
    except pymysql.MySQLError as e:
        logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
        logger.error(e)
        sys.exit()

    logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")
    
    with conn.cursor() as cursor:
        advertiser_id = event['queryStringParameters']['advertiser-id']
        query = "SELECT * FROM advertisers WHERE id = {};".format(advertiser_id)
        cursor.execute(query)
            
    if not (results := cursor.fetchone()):
        raise Exception('No existe el advertiser o campaign.')
    
    with conn.cursor() as cursor:
        campaign_id = event['queryStringParameters']['campaign-id']
        query = "SELECT * FROM advertiser_campaigns WHERE id = {};".format(campaign_id)
        cursor.execute(query)
            
    if not (results := cursor.fetchone()):
        raise Exception('No existe el advertiser o campaign.')
        
    with conn.cursor() as cursor:
        query = "SELECT zip_code FROM campaign_targeting WHERE campaign_id = {};".format(campaign_id)
        cursor.execute(query)
        
    if (results:=cursor.fetchall()):
        body = results
        return success_response(body)
    else:
        return {'zip-codes':[]}
