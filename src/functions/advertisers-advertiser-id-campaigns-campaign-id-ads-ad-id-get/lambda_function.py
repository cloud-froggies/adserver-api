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

    return body


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


    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        advertiser_id = event['queryStringParameters']['advertiser-id']
        query = "SELECT * FROM advertisers WHERE id = {};".format(advertiser_id)
        cursor.execute(query)
        
    if not (results := cursor.fetchone()):
        raise Exception('No existe el advertiser.')

    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        campaign_id = event['queryStringParameters']['campaign-id']
        query = "SELECT * FROM advertiser_campaigns WHERE id = {};".format(campaign_id)
        cursor.execute(query)
        
    if not (results := cursor.fetchone()):
        raise Exception('No existe la campaign.')

    # Parse out query string params/payload body
    ad_id = event['queryStringParameters']['ad-id']
    
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        query = "SELECT * FROM ads WHERE id = {} AND campaign_id = {};".format(ad_id, campaign_id)
        cursor.execute(query)
        
    if (results := cursor.fetchone()):
        body = results
        return success_response(body)
    else:
        raise Exception('No existe el advertiser o no tiene campaigns.')
