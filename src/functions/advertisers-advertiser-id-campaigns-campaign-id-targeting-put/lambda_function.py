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
        raise NotFoundException('No existe el campaign.')
        
    try:
        zip_codes = event['body']['zip-codes']
        zip_code_verify = map(lambda x: type(x)==str,zip_codes)
        if all(zip_code_verify):
            pass
        else:
            raise BadRequestException('Bad request, zip codes inválidos.')
            
        cursor = conn.cursor()
        query = "INSERT INTO campaign_targeting (campaign_id, zip_code) VALUES ({}, %s);".format(campaign_id)
        cursor.executemany(query, zip_codes)
        conn.commit()
        return
    except:
        raise BadRequestException('Bad request, zip codes inválidos.')
