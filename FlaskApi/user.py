import connectdb
from flask import jsonify,make_response

def create_user(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "INSERT INTO USER(username,password,email) VALUES(?,?,?)"
    cur.execute(q1,(data['username'],data['password'],data['email']))

    connectdb.commit_and_close(conn)
    return make_response(jsonify({"message": "User created successfully"}), 200)

def delete_user(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT 1 FROM User WHERE user_id = ?"
    cur.execute(q1, (data['user_id'],))

    select_result = cur.fetchone()[0]
    if not select_result:
        conn.close()
        return make_response(jsonify({"message": "User not found"}), 400)

    if(select_result == '1'):
        q2 = "DELETE FROM user WHERE user_id = ?"
        cur.execute(q2, (data['user_id'],))

        connectdb.commit_and_close(conn)
        return make_response(jsonify({"message": "User deleted successfully"}), 200)

    conn.close()
    return make_response(jsonify({"message": "Operation didn't work"}), 404)
       
def login(data):
    conn = connectdb.create_connection(connectdb.dbpath)
    cur = conn.cursor()
    
    q1 = "SELECT '1' FROM USER WHERE username = ? and password = ?"
    print(data)
    cur.execute(q1,(data['username'],data['password'],))
    
    select = cur.fetchone()[0]
    if not select:
        conn.close()
        return make_response(jsonify({"message": "username or password is wrong"}), 400)

    if(select == '1'):
        conn.close()
        return make_response(jsonify({"message":"login accepted"}), 200)

    conn.close()
    return make_response(jsonify({"message":"username or password is wrong"}), 400)

def recover_password(data):
    conn = connectdb.create_connection()
    cur = conn.cursor()

    q1 = "SELECT '1' FROM USER WHERE email = ?"
    cur.execute(q1,(data['email'],))
    select = cur.fetchone()[0]

    if(select == '1'):
        cur = conn.cursor()
        q2 = "SELECT password FROM USER WHERE email = ?"
        cur.execute(q2,(data['email'],))

        selected_pass = cur.fetchone()[0]
        conn.close()
        return make_response(jsonify({"recoveredPassword" : selected_pass}), 200)
    else:
        conn.close()
        return make_response(jsonify({"message":"email not found"}), 400)

def find_by_username(username):
    conn = connectdb.create_connection()
    cur = conn.cursor()
    q1 = "SELECT * FROM User WHERE username = ?"
    result = cur.execute(q1,(username,))
    row = result.fetchone()
    #if row:
        #user = User(*row)
   # else:
    #    user = None
    #return user

def find_by_id(id):
    conn = connectdb.create_connection()
    cur = conn.cursor()
    q1 = "SELECT * FROM id WHERE username = ?"
    result = cur.execute(q1,(id,))
    row = result.fetchone()
    #if row:
    #    user = User(*row)
    #else:
    #    user = None
    #return user 
    
def get_user_info(username, password):
    conn = connectdb.create_connection(connectdb.dbpath)
    cur = conn.cursor()

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
