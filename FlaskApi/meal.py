import connectdb
import json
from flask import jsonify, make_response

def add_new_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO Meal(meal_name) VALUES(?)"
    cur.execute(q1, (data['meal_name'],))

    connectdb.commit_and_close(conn)
    json_output = jsonify({"message": "meal created successfully"})

    return make_response(json_output, 200)

def get_meal_name(meal_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT meal_name FROM MEAL WHERE meal_id = ?"
    cur.execute(q1, (meal_id,))
    select = cur.fetchone()

    connectdb.commit_and_close(conn)

    if select:
        meal_name = select[0]
        return make_response(jsonify({'meal_name': meal_name}), 200)
    else:
        return make_response(jsonify({'error': 'Meal not found'}), 404)

def get_meal_by_id(meal_id):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT * FROM MEAL WHERE meal_id = ?"
    cur.execute(q1, (meal_id,))
    select = cur.fetchone()

    connectdb.commit_and_close(conn)

    if select:
        meal_data = {
            'meal_id': select[0],
            'meal_name': select[1]
        }
        return make_response(jsonify(meal_data), 200)
    else:
        return make_response(jsonify({'error': 'Meal not found'}), 404)

def get_meal_id_by_name(meal_name):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = f"SELECT meal_id FROM MEAL WHERE meal_name = '{meal_name}'"
    cur.execute(q1)
    select = cur.fetchone()

    connectdb.commit_and_close(conn)

    if select:
        meal_id = select[0]
        return make_response(jsonify({'meal_id': meal_id}), 200)
    else:
        return make_response(jsonify({'error': 'Meal not found'}), 404)

def get_meals():
    conn = connectdb.create_connection()
    cur = conn.cursor()

    my_query = "SELECT meal_name, meal_id FROM Meal"
    cur.execute(my_query)
    result = cur.fetchall()
    meals = [dict(zip([column[0] for column in cur.description], row)) for row in result]

    json_output = json.dumps(meals)
    connectdb.commit_and_close(conn)
    return make_response(jsonify(meals), 200)

