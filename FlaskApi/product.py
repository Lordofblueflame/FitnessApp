import connectdb
import json
from flask import jsonify,make_response

def show_all_products():
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT product_name,calories,proteins,fats,carbons FROM PRODUCTS"
    cur.execute(q1)
    db_output = cur.fetchall()

    connectdb. commit(conn)
    json_output = json.dumps( [dict(ix) for ix in db_output] )

    response = make_response(json_output, 200)
    response.headers["Content-Type"] = "application/json"
    return response

def get_product_by_name(data):
    try:
        conn = connectdb.create_connection()
        cur = conn.cursor()

        q1 = "SELECT * FROM Product WHERE product_name LIKE ?"

        # Use '%' to search for products containing the given substring
        search_term = '%' + data['product_name'] + '%'
        cur.execute(q1, (search_term,))
        results = cur.fetchall()

        product_list = []
        for result in results:
            product_dict = {
                "product_id": result[0],
                "product_name": result[1],
                "calories": result[2],
                "proteins": result[3],
                "fats": result[4],
                "carbons": result[5]
            }
            product_list.append(product_dict)

        if product_list:
            response = make_response(jsonify(product_list), 200)
        else:
            response = make_response(jsonify({"message": "No matching products found"}), 404)

        response.headers["Content-Type"] = "application/json"
        return response
    except Exception as e:
        print(f"Error: {str(e)}")
        response = make_response(jsonify({"message": "Internal Server Error"}), 500)
        response.headers["Content-Type"] = "application/json"
        return response
    finally:
        connectdb. commit(conn)

def get_product_by_id(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT * FROM Product WHERE product_id = ?"

    cur.execute(q1, (data['product_id'],))
    result = cur.fetchone()

    if result:
        product_dict = {
            "product_id": result[0],
            "product_name": result[1],
            "calories": result[2],
            "proteins": result[3],
            "fats": result[4],
            "carbons": result[5]
        }
        response = make_response(jsonify(product_dict), 200)
    else:
        response = make_response(jsonify({"message": "Product not found"}), 404)
    response.headers["Content-Type"] = "application/json"
    connectdb. commit(conn)
    return response

def add_new_product(data):
    try:
        conn = connectdb.create_connection()
        cur = conn.cursor()

        q1 = "INSERT INTO Product (product_name, calories, proteins, fats, carbons) VALUES (?, ?, ?, ?, ?)"
        cur.execute(q1, (data['product_name'], data['calories'], data['proteins'], data['fats'], data['carbons']))

        response = jsonify({"message": "Product created successfully"})
        response.status_code = 200     
        connectdb. commit(conn)   
        return response
    except Exception as e:
        print(f"Error: {str(e)}")
        response = jsonify({"message": "Internal Server Error"})
        response.status_code = 500
        return response