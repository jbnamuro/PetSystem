# config.py
import os
import MySQLdb

def get_db_connection():
    """
    Connect to MySQL using credentials stored in environment variables.
    """
    return MySQLdb.connect(
        host="localhost",
        user=os.getenv("MYSQL_USER", "root"),
        passwd=os.getenv("MYSQL_PASSWORD", ""),  # read password from env
        db=os.getenv("MYSQL_DB", "petsystem"),
        charset='utf8mb4'
    )
