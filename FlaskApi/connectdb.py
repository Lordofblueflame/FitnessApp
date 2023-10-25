import sqlite3
from sqlite3 import Error

dbpath = r"D:\Repo\FitnessApp\SQLiteDatabase\FitnessAppDatabase.db"
default_username = "Kamiloso515"
default_password = "123456"
defaulut_email = "Cepkamil@gmail.com"

def create_connection(db_file = dbpath):
    try:
        conn = sqlite3.connect(db_file)
        return conn
    except sqlite3.Error as e:
        print(e)
    return None

def query_db(query, cur, args=(), one=False):
    cur.execute(query, args)
    r = [dict((cur.description[i][0], value) \
               for i, value in enumerate(row)) for row in cur.fetchall()]
    cur.connection.close()
    return (r[0] if r else None) if one else r

def commit_and_close(conn):
    if(conn != None): 
        try:
            conn.commit()
            conn.close()
            return True;
        except Error as e:
            print(e)
    return False;
