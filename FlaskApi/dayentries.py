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

def remove_day_entry(entry_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    delete_query = "DELETE FROM UserDayEntries WHERE entry_id = ?"
    cur.execute(delete_query, (entry_id,))

    connectdb.commit(conn)
    json_output = jsonify({"message": "entry removed"})
    return make_response(json_output, 200)

def update_day_entry(entry_id, new_product_in_meal):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    update_query = "UPDATE UserDayEntries SET product_in_meal = ? WHERE entry_id = ?"
    cur.execute(update_query, (new_product_in_meal, entry_id))

    connectdb.commit(conn)
    json_output = jsonify({"message": "entry updated"})
    return make_response(json_output, 200)

def find_day_entry(user_id,date,product_in_meal):
    conn = connectdb.create_connection()
    cur = conn.cursor()
    
    query = "SELECT entry_id FROM UserDayEntries WHERE user_id = ? AND date = ? AND product_in_meal = ? LIMIT 1"
    cur.execute(query, (user_id, date, product_in_meal))

    result = cur.fetchone()

    if result:
        entry_id = result[0]
        return make_response(jsonify({"entry_id": entry_id}), 200)
    else:
        return make_response(jsonify({"error": "No matching entry found"}), 404)