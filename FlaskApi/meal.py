import connectdb
import json
from flask import jsonify,make_response

def add_new_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO Meal(meal_name) VALUES(?)"
    cur.execute(q1,(data['meal_name'],))

    connectdb.commit_and_close(conn)
    json_output = jsonify({"message": "meal created successfully"})

    return make_response(json_output, 200)

def get_meal_name(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT meal_name FROM MEAL WHERE meal_id = ?"
    cur.execute(q1,(data['meal_id'],))
    select = cur.fetchone()

    connectdb.commit_and_close(conn)
    json_output = jsonify({'meal_name': select})

    return make_response(json_output, 200)

def get_meal_by_id(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT * FROM MEAL WHERE meal_id = ?"
    cur.execute(q1,(data['meal_id'],))
    select = cur.fetchone()

    connectdb.commit_and_close(conn)
    json_output = jsonify(select)
    
    return make_response(json_output, 200)

def get_meal_id_by_name(mealName):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = f"SELECT meal_id FROM MEAL WHERE meal_name = '{mealName}'"
    cur.execute(q1)
    select = cur.fetchone()

    connectdb.commit_and_close(conn)
    json_output = jsonify(select)
    
    return make_response(json_output, 200)

def get_meals():
    conn = connectdb.create_connection()
    cur = conn.cursor()

    my_query = connectdb.query_db("SELECT meal_name, meal_id FROM Meal", cur)

    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)
    return make_response(json_output, 200)
