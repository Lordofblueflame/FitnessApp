import connectdb
import json
from flask import jsonify,make_response

def add_new_entry(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO UserDayEntries(user_id,date,water,workout,product_in_meal) VALUES(?,?,?,?,?)"
    cur.execute(q1,(data['user_id'],data['date'],data['water'],data['workout'],data['product_in_meal']))

    connectdb.commit_and_close(conn)
    json_output = jsonify({"message": "new entry added"})

    return make_response(json_output, 200)

def get_current_day_entries(date, user_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    my_query = connectdb.query_db(f"SELECT * FROM UserDayEntries WHERE user_id = {user_id} and date = {date} ",cur)

    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)  
    return make_response(json_output,200)

def get_user_dayentries(user_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    my_query = connectdb.query_db(f"SELECT * FROM UserDayEntries WHERE user_id = {user_id} ",cur)

    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)  
    return make_response(json_output,200)

