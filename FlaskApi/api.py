from flask import Flask,request, jsonify, make_response
import user
import product
import meal
import productsinmeal
import dayentries
import connectdb
from flask_restx import Api, Resource, fields, reqparse
from flask_cors import CORS

app = Flask(__name__)
CORS(app)
api = Api(app)
api.title = "Fitness App -"
api.description = "TechStack: Flutter,Python,Flask,Anaconda,RestApi"
api.version = "1.0"
api.authorizations = {
    "apikey": {
        "type": "apiKey",
        "in": "header",
        "name": "Authorization"
    }
}

login_request_model = api.model('LoginRequestModel', {
    'username': fields.String(required=True, description='Username or login'),
    'password': fields.String(required=True, description='User password'),
})

create_user_request_model = api.model('CreateUserRequestModel', {
    'username': fields.String(required=True, description='Username or login'),
    'password': fields.String(required=True, description='User password'),
    'email': fields.String(required=True, description='Email of the user')
})

delete_user_request_model = api.model('DeleteUserRequestModel', {
    'user_id': fields.Integer(required=True, description='User ID'),
})

recover_password_request_model = api.model('RecoverPasswordRequestModel', {
    'email': fields.String(required=True, description='Email of the user'),
})

update_weight_height_request_model = api.model('UpdateWeightHeightRequestModel', {
    'user_id': fields.Integer(required=True, description='User ID'),
    'weight': fields.Float(required=True, description='Weight'),
    'height': fields.Float(required=True, description='Height'),
})

change_password_request_model = api.model('ChangePasswordRequestModel', {
    'user_id': fields.Integer(required=True, description='User ID'),
    'current_password': fields.String(required=True, description='Current password'),
    'new_password': fields.String(required=True, description='New password'),
})

product_model = api.model('Product', {
    'product_name': fields.String(description = 'Name of the product', example = 'mleko'),
    'calories': fields.Float(description = 'Calories in the product', example = '150'),
    'proteins': fields.Float(description = 'Proteins in the product', example = '5'),
    'fats': fields.Float(description = 'Fats in the product', example = '7'),
    'carbons': fields.Float(description = 'Carbons in the product', example = 0.5)
})

product_in_meal_model = api.model('ProductInMeal', {
    'meal_id': fields.Integer(description ='Meal ID', example = 1),
    'product_id': fields.Integer(description ='Product ID', example = 5),
})

day_entries_model = api.model('UserDayEntries', {
    'user id': fields.Integer(description = 'user id', example = 7),
    'date': fields.String(description = 'date entry was made', example='2023-07-01'),
    'water': fields.Integer(description = 'Amount of water user consumed', example = 0),
    'workout': fields.Integer(description='Meal ID', example = 0),
    'products_in_meal': fields.Integer(description ='Product in meal id', example = 3),
})

user_ns = api.namespace('user', description='User operations')
product_ns = api.namespace('product', description='Product operations')
meal_ns = api.namespace('meal', description='Meal operations')
productinmeal_ns = api.namespace('productinmeal', description='Products in Meal operations')
dayentries_ns = api.namespace('dayentries', description='Day Entries operations')

@user_ns.route('/register')
class UserRegister(Resource):
    @api.doc(description='Create a new user')
    @api.expect(create_user_request_model, validate=True)  # Use the create_user_request_model
    def post(self):
        data = request.get_json()
        retval = user.create_user(data)
        return retval

@user_ns.route('/deleteuser')
class UserDelete(Resource):
    @api.doc(description='Delete a user by user_id')
    @api.expect(delete_user_request_model, validate=True)  # Use the delete_user_request_model
    def delete(self):
        data = request.get_json()
        retval = user.delete_user(data)
        return retval

@user_ns.route('/login')
class UserLogin(Resource):
    @api.doc(description='User login')
    @api.expect(login_request_model, validate=True)  # Use the login_request_model
    def post(self):
        data = request.get_json()
        retval = user.login(data)
        return retval
    
email_parser = reqparse.RequestParser()
email_parser.add_argument('email', type=str, required=True, help='Email of the user')

@user_ns.route('/recoverpassword')
class UserRecoverPassword(Resource):
    @api.doc(description='Recover user password by email')
    @api.expect(email_parser)
    def get(self):
        email = request.args.get('email')
        retval = user.recover_password(email)
        return jsonify(retval)


@user_ns.route('/getuserinfo', methods=['POST'])
class UserGetUserInfo(Resource):
    @api.doc(description='Get user information by login and password')
    @api.expect(login_request_model, validate=True)  
    def post(self):
        data = request.get_json() 
        retval = user.get_user_info(data)
        return jsonify(retval) 

@user_ns.route('/updateweightheight')
class UpdateWeightHeight(Resource):
    @api.doc(description='Update user weight and height')
    @api.expect(update_weight_height_request_model, validate=True)  # Use the update_weight_height_request_model
    def post(self):
        conn = connectdb.create_connection()
        user_id = api.payload.get('user_id')
        weight = api.payload.get('weight')
        height = api.payload.get('height')

        if conn is not None:
            cur = conn.cursor()
            cur.execute('UPDATE "User" SET weight=?, height=? WHERE user_id=?', (weight, height, user_id))
            conn.commit()
            
            return {'message': 'Weight and height updated successfully.'}
        else:
            return {'message': 'Database connection error.'}, 500

@user_ns.route('/changepassword')
class ChangePassword(Resource):
    @api.doc(description='Change user password')
    @api.expect(change_password_request_model, validate=True)  # Use the change_password_request_model
    def post(self):
        user_id = api.payload.get('user_id')
        current_password = api.payload.get('current_password')
        new_password = api.payload.get('new_password')

        conn = connectdb.create_connection()
        if conn is not None:
            cursor = conn.cursor()
            cursor.execute('SELECT password FROM "User" WHERE user_id=?', (user_id,))
            row = cursor.fetchone()
            if row and row[0] == current_password:
                cursor.execute('UPDATE "User" SET password=? WHERE user_id=?', (new_password, user_id))
                conn.commit()
                
                return {'message': 'Password changed successfully.'}
            else:
                return {'message': 'Current password is incorrect.'}, 401
        else:
            return {'message': 'Database connection error.'}, 500
        
get_product_parser = reqparse.RequestParser()
get_product_parser.add_argument('product_id', type=int, required=True, help='product id')

get_product_by_name_parser = reqparse.RequestParser()
get_product_by_name_parser.add_argument('product_name', type=str, required=True, help='product name')

@product_ns.route('/addproduct')
class AddProduct(Resource):
    @product_ns.doc(description='Add a new product')
    @product_ns.expect(product_model)
    def post(self):
        data = request.get_json()
        retval = product.addNewProduct(data)
        return retval
    
@product_ns.route('/getproduct')
class GetProduct(Resource):
    @product_ns.doc(description='Get a product by product_id')
    @product_ns.expect(get_product_parser)
    def get(self):
        data = get_product_parser.parse_args()
        retval = product.get_product_by_id(data)
        return retval

@product_ns.route('/getproductbyname')
class GetProductByName(Resource):
    @product_ns.doc(description='Get a product by product_name')
    @product_ns.expect(get_product_by_name_parser)
    def get(self):
        data = get_product_by_name_parser.parse_args()
        retval = product.get_product_by_name(data)
        return retval
    
add_meal_model = api.model('MealModel', {
    'meal_id': fields.Integer(description ='Meal ID', example = 1),
    'meal_name': fields.String(description ='Meal Name', example = 'Breakfast'),
})

add_meal_model = api.model('AddMealModel', {
    'meal_name': fields.String(description='Meal name', example='Breakfast'),
})

get_meal_parser = reqparse.RequestParser()
get_meal_parser.add_argument('meal_id', type=int, required=True, help='Meal ID')

get_meal_id_parser = reqparse.RequestParser()
get_meal_id_parser.add_argument('meal_name', type=str, required=True, help='Meal Name')

@meal_ns.route('/addmeal')
class AddMeal(Resource):
    @meal_ns.doc(description='Add a new meal')
    @meal_ns.expect(add_meal_model)
    def post(self):
        data = request.get_json()
        retval = meal.add_new_meal(data)
        return retval

@meal_ns.route('/getmealname')
class GetMealName(Resource):
    @meal_ns.doc(description='Get meal name by meal_id')
    @meal_ns.expect(get_meal_parser)
    def get(self):
        args = get_meal_parser.parse_args()
        meal_id = args['meal_id']
        retval = meal.get_meal_name(meal_id)
        return retval

@meal_ns.route('/getmealbyid')
class GetMealById(Resource):
    @meal_ns.doc(description='Get meal by meal_id')
    @meal_ns.expect(get_meal_parser)
    def get(self):
        meal_id = request.args.get('meal_id')
        retval = meal.get_meal_by_id(meal_id)
        return retval

@meal_ns.route('/getmealidbyname')
class GetMealIdByName(Resource):
    @meal_ns.doc(description='Get meal_id by meal name')
    @meal_ns.expect(get_meal_id_parser)
    def get(self):
        args = get_meal_id_parser.parse_args()
        meal_name = args['meal_name']
        retval = meal.get_meal_id_by_name(meal_name)
        return retval

@meal_ns.route('/getmeals')
class GetMeals(Resource):
    @meal_ns.doc(description='Get all meals')
    def get(self):
        retval = meal.get_meals()
        return retval
    
@productinmeal_ns.route('/addproductinmeal')
class AddProductInMeal(Resource):
    @productinmeal_ns.doc(description='Add a product to a meal')
    @productinmeal_ns.expect(product_in_meal_model)
    def post(self):
        data = productinmeal_ns.payload
        retval = productsinmeal.add_product_in_meal(data)
        return retval

@productinmeal_ns.route('/getproductinmeal')
class GetProductInMeal(Resource):
    @productinmeal_ns.doc(description='Get product in meal by description')
    @productinmeal_ns.param('productinmeal', 'Product in meal description')
    def get(self):
        data = request.args.get('productinmeal')
        retval = productsinmeal.get_product_in_meal(data)
        return retval

get_day_entries_parser = reqparse.RequestParser()
get_day_entries_parser.add_argument('date', type=str, required=True, help='Date in YYYY-MM-DD format')
get_day_entries_parser.add_argument('user_id', type=str, required=True, help='User ID')

@dayentries_ns.route('/getdayentries')
class GetDayEntries(Resource):
    @dayentries_ns.doc(description='Get day entries by date and user_id')
    @dayentries_ns.expect(get_day_entries_parser)
    def get(self):
        date = request.args.get('date')
        user_id = request.args.get('user_id')
        retval = dayentries.get_current_day_entries(date,user_id)
        return retval

@dayentries_ns.route('/addnewentry')
class AddNewEntry(Resource):
    @dayentries_ns.doc(description='Add a new day entry')
    @dayentries_ns.expect(day_entries_model)
    def post(self):
        data = request.get_json()
        retval = dayentries.add_new_entry(data)
        return retval

get_user_day_entries_parser = reqparse.RequestParser()
get_user_day_entries_parser.add_argument('user_id', type=int, required=True, help='User ID')

@dayentries_ns.route('/getuserdayentries')
class GetUserDayEntries(Resource):
    @dayentries_ns.doc(description='Get day entries by user_id')
    @dayentries_ns.expect(get_user_day_entries_parser)
    def get(self):
        user_id = request.args.get('user_id')
        retval = dayentries.get_user_dayentries(user_id)
        return retval
    
if __name__ == '__main__':
    app.run(host = "192.168.0.91", port = '5000')
