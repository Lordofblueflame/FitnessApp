import connectdb
import json
from flask import jsonify,make_response

def show_all_products():
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT product_name,calories,proteins,fats,carbons FROM PRODUCTS"
    cur.execute(q1)
    db_output = cur.fetchall()

    connectdb.commit_and_close(conn)
    json_output = json.dumps( [dict(ix) for ix in db_output] )

    return make_response(json_output, 200)

def search_products_by_name(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()
        
    my_query = connectdb.query_db(f'SELECT * FROM Product where product_name like "%{data}%"',cur)

    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)  
    return make_response(json_output,200)

def get_product_by_id(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    my_query = connectdb.query_db(f'SELECT * FROM Product where product_id = {data}',cur)

    json_output = json.dumps(my_query)
    connectdb.commit_and_close(conn)  
    return make_response(json_output,200)

def add_new_product(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO Product(product_name,calories,proteins,fats,carbons) VALUES(?,?,?,?,?)"
    cur.execute(q1,(data['product_name'],data['calories'],data['proteins'],data['fats'].data['carbons']))

    connectdb.commit_and_close(conn)
    json_output = jsonify({"message": "product created successfully"})
    return make_response(json_output, 200)