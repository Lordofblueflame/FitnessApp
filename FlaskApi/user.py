import connectdb
from flask import jsonify,make_response

def create_user(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO USER(username,password,email) VALUES(?,?,?)"
    cur.execute(q1,(data['username'],data['password'],data['email']))

    connectdb. commit(conn)
    return make_response(jsonify({"message": "User created successfully"}), 200)

def delete_user(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT 1 FROM User WHERE user_id = ?"
    cur.execute(q1, (data['user_id'],))

    select_result = cur.fetchone()[0]
    if not select_result:
        
        return make_response(jsonify({"message": "User not found"}), 400)

    if(select_result == 1):
        q2 = "DELETE FROM user WHERE user_id = ?"
        cur.execute(q2, (data['user_id'],))

        connectdb. commit(conn)
        return make_response(jsonify({"message": "User deleted successfully"}), 200)

    
    return make_response(jsonify({"message": "Operation didn't work"}), 404)
       
def login(data):
    conn = connectdb.create_connection(connectdb.dbpath)
    cur = conn.cursor()
    
    q1 = "SELECT '1' FROM USER WHERE username = ? and password = ?"
    cur.execute(q1,(data['username'],data['password'],))
    
    select = cur.fetchone()[0]
    if not select:
        
        return make_response(jsonify({"message": "username or password is wrong"}), 400)

    if(select == '1'):
        
        return make_response(jsonify({"message":"login accepted"}), 200)

    
    return make_response(jsonify({"message":"username or password is wrong"}), 400)

def recover_password(email):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT '1' FROM USER WHERE email = ?"
    cur.execute(q1, (email,))
    select = cur.fetchone()

    if select:
        q2 = "SELECT password FROM USER WHERE email = ?"
        cur.execute(q2, (email,))
        selected_pass = cur.fetchone()[0]
        
        return selected_pass
    else:
        
        return None


    
def get_user_info(data):
    conn = connectdb.create_connection(connectdb.dbpath)
    cur = conn.cursor()

    username = data.get('username')
    password = data.get('password')

    q1 = "SELECT user_id,username,email,weight,height FROM User WHERE username = ? AND password = ?"
    cur.execute(q1, (username,password,))

    result = cur.fetchone()
    if result:
        user_info = {
            'userid': result[0],
            'username': result[1],
            'email': result[2],
            'weight': result[3],
            'height': result[4]
        }
        return user_info
    else:
        return None
