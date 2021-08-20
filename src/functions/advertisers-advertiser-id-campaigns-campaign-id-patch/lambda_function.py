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

def check_params(body):
    acceptable_params = {
        "bid": lambda x: type(x)== float or type(x) ==int,
        "budget":lambda x: type(x)== float or type(x) ==int,
        "status":lambda x: type(x)== bool or type(x) ==int
        
    }
    if not (body):
        raise Exception("Sin argumentos de body validos")
    for key,value in body.items():
        if key not in acceptable_params:
            raise Exception("Sin argumentos de body validos")
        
        if not (acceptable_params[key](value)):
            raise Exception(f"Sin {key} o invalido")
            
        
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
        raise Exception('No existe el advertiser o campaign.')

    # Parse out query string params/payload body
    campaign_id = event['queryStringParameters']['campaign-id']
    
    with conn.cursor(pymysql.cursors.DictCursor) as cursor:
        query = "SELECT * FROM advertiser_campaigns WHERE id = {} AND advertiser_id = {};".format(campaign_id,advertiser_id)
        cursor.execute(query)
    
    if not (results := cursor.fetchone()):
        raise Exception('No existe el advertiser o campaign.')

    body_params = event["body"]
    
    check_params(body_params)

    params_into_str = map(lambda x: f'{x[0]} = {x[1]}',body_params.items())

    cursor = conn.cursor()
    query = "UPDATE advertiser_campaigns SET {} WHERE id = {};".format(', '.join(params_into_str),campaign_id)
    print(query)
    cursor.execute(query)
    conn.commit()
    return