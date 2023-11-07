import connectdb
import json
from flask import jsonify,make_response

def add_new_entry(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO UserDayEntries(user_id,date,water,workout,product_in_meal) VALUES(?,?,?,?,?)"
    cur.execute(q1,(data['user_id'],data['date'],data['water'],data['workout'],data['product_in_meal']))
    json_output = jsonify({"message": "new entry added"})
    
    connectdb. commit(conn)
    return make_response(json_output, 200)

def get_current_day_entries(date, user_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    user_id_str = str(user_id)
    date_str = str(date)
    my_query = f"SELECT * FROM UserDayEntries WHERE user_id = '{user_id_str}' and date = '{date_str}'"
    cur.execute(my_query)
    result = cur.fetchall()

    entries = [dict(zip([column[0] for column in cur.description], row)) for row in result]
    json_output = json.dumps(entries)

    connectdb. commit(conn)
    return make_response(json_output, 200)

def get_user_dayentries(user_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    user_id_str = str(user_id)
    my_query = f"SELECT * FROM UserDayEntries WHERE user_id = '{user_id_str}'"
    cur.execute(my_query)
    result = cur.fetchall()

    entries = [dict(zip([column[0] for column in cur.description], row)) for row in result]
    json_output = json.dumps(entries)

    connectdb. commit(conn)
    return make_response(json_output, 200)

