import connectdb
import json
from flask import jsonify,make_response

import connectdb  # Assuming you have a module named connectdb

def add_product_in_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    meal_id = data['meal_id']
    product_id = data['product_id']

    q_check = "SELECT products_in_meal FROM PRODUCTSINMEAL WHERE meal_id = ? AND product_id = ?"
    cur.execute(q_check, (meal_id, product_id))
    existing_product = cur.fetchone()

    if existing_product:
        
        return make_response(jsonify({'products_in_meal': existing_product[0]}), 200)

    else:
        q_insert = "INSERT INTO PRODUCTSINMEAL(meal_id, product_id) VALUES(?, ?)"
        cur.execute(q_insert, (meal_id, product_id))
        products_in_meal = cur.lastrowid

    json_output = jsonify({'products_in_meal': products_in_meal})
    connectdb. commit(conn)  
    return make_response(json_output, 200)


def get_product_in_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()
        
    my_query = connectdb.query_db(f'SELECT * FROM PRODUCTSINMEAL where products_in_meal = {data}',cur)
    
    json_output = json.dumps(my_query)
    connectdb. commit(conn)  
    return make_response(json_output,200)