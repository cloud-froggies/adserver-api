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
db_name = os.environ['db_name']

# Connection
#connection = pymysql.connect(endpoint, user=username, passwd=password, db=database_name)
try:
    conn = pymysql.connect(host=endpoint, user=username, passwd=password, db=db_name, connect_timeout=5)
except pymysql.MySQLError as e:
    logger.error("ERROR: Unexpected error: Could not connect to MySQL instance.")
    logger.error(e)
    sys.exit()

logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


def lambda_handler(event, context):
    with conn.cursor() as cursor:
        cursor.execute("SELECT * FROM advertisers")
        for row in cursor:
            print(row)
    
    conn.commit()
    
    
    """ cursor = connection.cursor()
	cursor.execute('SELECT * FROM advertisers')

	rows = cursor.fetchall()

	for row in rows:
		print(row) """
        
    