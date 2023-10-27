import connectdb
import json
from flask import jsonify,make_response

# helper api don't depends on it's own need dayentry to work

def add_product_in_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    meal_id = data['meal_id']
    product_id = data['product_id']

    # Sprawdzenie, czy produkt już istnieje w PRODUCTSINMEAL
    q_check = "SELECT products_in_meal FROM PRODUCTSINMEAL WHERE meal_id = ? AND product_id = ?"
    cur.execute(q_check, (meal_id, product_id))
    existing_product = cur.fetchone()

    if existing_product:
        # Produkt już istnieje, zwróć istniejące id
        products_in_meal = existing_product[0]
    else:
        # Dodaj nowy produkt do PRODUCTSINMEAL
        q_insert = "INSERT INTO PRODUCTSINMEAL(meal_id, product_id) VALUES(?, ?)"
        cur.execute(q_insert, (meal_id, product_id))
        products_in_meal = cur.lastrowid

    conn.commit()
    conn.close()

    json_output = jsonify({'products_in_meal': products_in_meal})
    return make_response(json_output, 200)

def get_product_in_meal(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()
        
    my_query = connectdb.query_db(f'SELECT * FROM PRODUCTSINMEAL where products_in_meal = {data}',cur)
    
    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)  
    return make_response(json_output,200)