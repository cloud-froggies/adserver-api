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

    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        campaign_id = event['queryStringParameters']['campaign-id']
        query = "SELECT * FROM advertiser_campaigns WHERE id = {};".format(campaign_id)
        cursor.execute(query)
        
    if not (results := cursor.fetchone()):
        raise NotFoundException('No existe la campaign.')

    try:
        headline = event['body']['headline']
        description = event['body']['description']
        url = event['body']['url']
        cursor = conn.cursor()
        query = "INSERT INTO ads (campaign_id, headline, description, url) VALUES ({}, '{}', '{}', '{}');".format(campaign_id, headline, description, url)
        cursor.execute(query)
        insert_id = conn.insert_id()
        conn.commit()
        return success_response({'id': insert_id})
    except:
        raise BadRequestException('Sin headline, description o url, o vacíos.')