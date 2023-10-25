from flask import Flask,request, jsonify, make_response
import user
import product
import meal
import productsinmeal
import dayentries
import connectdb
from flask_restx import Api, Resource, fields

app = Flask(__name__)
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

login_password_model = api.model('LoginPasswordModel', {
    'username': fields.String(description='Username or login', example='test'),
    'password': fields.String(description='User password', example='test'),
})

product_model = api.model('Product', {
    'product_name': fields.String(description='Name of the product', required=True),
    'calories': fields.Float(description='Calories in the product', required=True),
    'proteins': fields.Float(description='Proteins in the product', required=True),
    'fats': fields.Float(description='Fats in the product', required=True),
    'carbons': fields.Float(description='Carbons in the product', required=True)
})

user_ns = api.namespace('user', description='User operations')
@user_ns.route('/register')
class UserRegister(Resource):
    @api.doc(description='Create a new user')
    def post(self):
        data = request.get_json()
        retval = user.create_user(data)
        return retval

@user_ns.route('/deleteuser')
class UserDelete(Resource):
    @api.doc(description='Delete a user by user_id')
    def delete(self):
        data = request.get_json()
        retval = user.delete_user(data)
        return retval

@user_ns.route('/login')
class UserLogin(Resource):
    @api.doc(description='User login')
    @api.expect(login_password_model, validate=True)
    def post(self):
        data = request.get_json()
        retval = user.login(data)
        return retval

@user_ns.route('/recoverpassword')
class UserRecoverPassword(Resource):
    @api.doc(description='Recover user password by email')
    def get(self):
        data = request.get_json()
        retval = user.recover_password(data)
        return retval

@user_ns.route('/getuserinfo', methods=['POST'])
class UserGetUserInfo(Resource):
    @api.doc(description='Get user information by login and password')
    @api.expect(login_password_model, validate=True)
    def post(self):
        data = request.get_json() 
        login = data.get('username')
        password = data.get('password')
        retval = user.get_user_info(login, password)
        print(retval)
        return jsonify(retval) 

@user_ns.route('/update_weight_height')
class UpdateWeightHeight(Resource):
    @api.doc(description='Update user weight and height')
    @api.expect(api.parser().add_argument('user_id', type=int, help='User ID', required=True)
                            .add_argument('weight', type=float, help='Weight', required=True)
                            .add_argument('height', type=float, help='Height', required=True),
                validate=True)
    def post(self):
        conn = connectdb.create_connection()
        user_id = api.payload.get('user_id')
        weight = api.payload.get('weight')
        height = api.payload.get('height')

        if conn is not None:
            cur = conn.cursor()
            cur.execute('UPDATE "User" SET weight=?, height=? WHERE user_id=?', (weight, height, user_id))
            conn.commit()
            conn.close()
            return {'message': 'Weight and height updated successfully.'}
        else:
            return {'message': 'Database connection error.'}, 500

@user_ns.route('/change_password')
class ChangePassword(Resource):
    @api.doc(description='Change user password')
    @api.expect(api.parser().add_argument('user_id', type=int, help='User ID', required=True)
                            .add_argument('current_password', type=str, help='Current password', required=True)
                            .add_argument('new_password', type=str, help='New password', required=True),
                validate=True)
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
                conn.close()
                return {'message': 'Password changed successfully.'}
            else:
                return {'message': 'Current password is incorrect.'}, 401
        else:
            return {'message': 'Database connection error.'}, 500

product_ns = api.namespace('product', description='Product operations')
@product_ns.route('/addproduct')
class AddProduct(Resource):
    @api.doc(description='Add a new product')
    @api.expect(product_model)
    def post(self):
        data = request.get_json()
        retval = product.add_new_product(data)
        return retval

@product_ns.route('/getproduct')
class GetProduct(Resource):
    @api.doc(description='Get a product by product_id')
    def get(self):
        data = request.args.get('product_id')
        retval = product.get_product_by_id(data)
        return retval

@product_ns.route('/searchproductbyname')
class SearchProductByName(Resource):
    @api.doc(description='Search products by name')
    def get(self):
        data = request.args.get('product_name')
        retval = product.search_products_by_name(data)
        return retval

meal_ns = api.namespace('meal', description='Meal operations')
@meal_ns.route('/addmeal')
class AddMeal(Resource):
    @api.doc(description='Add a new meal')
    @api.expect(product_model)
    def post(self):
        data = request.get_json()
        retval = meal.add_new_meal(data)
        return retval

@meal_ns.route('/getmealname')
class GetMealName(Resource):
    @api.doc(description='Get meal name by meal_id')
    def get(self):
        data = request.args.get('meal_id')
        retval = meal.get_meal_name(data)
        return retval

@meal_ns.route('/getmealbyid')
class GetMealById(Resource):
    @api.doc(description='Get meal by meal_id')
    def get(self):
        data = request.args.get('meal_id')
        retval = meal.get_meal_by_id(data)
        return retval

@meal_ns.route('/getmealidbyname')
class GetMealIdByName(Resource):
    @api.doc(description='Get meal_id by meal name')
    def get(self):
        mealName = request.args.get('mealName')
        retval = meal.get_meal_id_by_name(mealName)
        return retval

@meal_ns.route('/getmeals')
class GetMeals(Resource):
    @api.doc(description='Get all meals')
    def get(self):
        retval = meal.get_meals()
        return retval
    

productinmeal_ns = api.namespace('productinmeal', description='Products in Meal operations')
product_in_meal_model = productinmeal_ns.model('ProductInMeal', {
    'meal_id': fields.Integer(description='Meal ID', required=True),
    'product_id': fields.Integer(description='Product ID', required=True),
    'products_in_meal': fields.String(description='Product in meal description')
})

product_in_meal_data = []

@productinmeal_ns.route('/addproductinmeal')
class AddProductInMeal(Resource):
    @productinmeal_ns.doc(description='Add a product to a meal')
    @productinmeal_ns.expect(product_in_meal_model)
    def post(self):
        data = productinmeal_ns.payload
        # You need to implement logic to add a product to a meal based on the payload data
        # Replace the following line with your implementation
        retval = {'message': 'Added product to meal: {}'.format(data)}
        return retval

@productinmeal_ns.route('/getproductinmealbyid')
class GetProductInMealById(Resource):
    @productinmeal_ns.doc(description='Get product in meal by ID')
    @productinmeal_ns.param('productinmeal', 'Product in meal ID')
    def get(self):
        productinmeal_id = int(request.args.get('productinmeal'))
        # You need to implement logic to fetch product in meal by ID
        # Replace the following line with your implementation
        retval = {'message': 'Fetching product in meal by ID: {}'.format(productinmeal_id)}
        return retval

@productinmeal_ns.route('/getproductinmeal')
class GetProductInMeal(Resource):
    @productinmeal_ns.doc(description='Get product in meal by description')
    @productinmeal_ns.param('productinmeal', 'Product in meal description')
    def get(self):
        data = request.args.get('productinmeal')
        retval = productsinmeal.get_product_in_meal(data)
        return retval

dayentries_ns = api.namespace('dayentries', description='Day Entries operations')
day_entries_model = dayentries_ns.model('DayEntries', {
    'date': fields.String(description='Date in YYYY-MM-DD format', required=True),
    'user_id': fields.Integer(description='User ID', required=True),
    'water': fields.Float(description='Water intake'),
    'workout': fields.String(description='Workout description'),
    'product_in_meal': fields.String(description='Product in meal description')
})
day_entries_data = []

@dayentries_ns.route('/getdayentries')
class GetDayEntries(Resource):
    @dayentries_ns.doc(description='Get day entries by date and user_id')
    @dayentries_ns.expect(day_entries_model)
    def get(self):
        data = dayentries_ns.payload
        date = data['date']
        user_id = data['user_id']
        # You need to implement logic to fetch day entries based on date and user_id
        # Replace the following line with your implementation
        retval = {'message': 'Fetching day entries for date {} and user_id {}'.format(date, user_id)}
        return retval

@dayentries_ns.route('/addnewentry')
class AddNewEntry(Resource):
    @dayentries_ns.doc(description='Add a new day entry')
    @dayentries_ns.expect(day_entries_model)
    def post(self):
        data = dayentries_ns.payload
        # You need to implement logic to add a new day entry based on the payload data
        # Replace the following line with your implementation
        retval = {'message': 'Added new day entry: {}'.format(data)}
        return retval

@dayentries_ns.route('/getuserdayentries')
class GetUserDayEntries(Resource):
    @dayentries_ns.doc(description='Get day entries by user_id')
    @dayentries_ns.param('user_id', 'User ID')
    def get(self):
        data = int(request.args.get('user_id'))
        retval = dayentries.get_user_dayentries(data)
        return retval
    
if __name__ == '__main__':
    app.run(host = "192.168.1.125", port = '5000')

#curl -X GET -H "Content-Type: application/json" -d "{ \"email\" : \"Cepkamil@gmail.com\" }" http://192.168.0.178:5000/user/recoverpassword

#curl -X GET "http://192.168.0.178:5000/dayentries/getuserdayentries?user_id=7"

#curl -X GET "http://192.168.0.178:5000/user/getuserinfo?login=test&password=test"

#curl -X GET "http://192.168.0.178:5000/dayentries/getdayentries?date=2023-06-30&user_id=123"

#curl -X GET 'http://192.168.0.178:5000/productinmeal/getproductinmealbyid?productinmeal=3'

#curl -X GET "http://192.168.0.178:5000/dayentries/getdayentries?date=2023-06-30&user_id=7"

#curl -X POST -H "Content-Type: application/json" -d "{\"user_id\": 1, \"weight\": 70,\"height\": 180}" http://192.168.0.178:5000/api/update_weight_height

#curl -X POST -H "Content-Type: application/json" -d "{\"user_id\": 1, \"current_password\": \"123456\",\"new_password\": \"180\"}" http://192.168.0.178:5000/api/change_password

#curl -X POST -H "Content-Type: application/json" -d "{\"meal_id\": 1, \"product_id\": 5}" http://192.168.0.178:5000/productinmeal/addproductinmeal

#curl -X GET -H "Content-Type: application/json" -d "{ \"product_name\" : \"m\" }" http://192.168.0.178:5000/product/searchproductbyname

#curl -X POST -H "Content-Type: application/json" -d "{ \"username\" : \"Kamiloso515\" , \"password\" : \"123456\" }" http://127.0.0.1:5000/login

#curl -X POST -H "Content-Type: application/json" -d "{ \"username\" : \"testuser\", \"password\" : \"testpass\", \"email\" : \"test@test.com\"}" http://127.0.0.1:5000/createuser