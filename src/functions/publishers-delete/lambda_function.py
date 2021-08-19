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


# Handler
def lambda_handler(event, context):
    try:
        cursor = conn.cursor()
        query = "DELETE FROM advertisers;"
        cursor.execute(query)
        conn.commit()
        return 
    except:
        raise Exception('Error al borrar.')
    