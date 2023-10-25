import 'data_models/dayentries.dart';
import 'data_models/meal.dart';
import 'data_models/productsinmeal.dart';
import 'data_models/user.dart';
import 'main_app_route.dart';
import 'views/login_related/forgot_password_view.dart';
import 'views/login_related/login_view.dart';
import 'views/login_related/register_view.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatefulWidget {
  const LoginApp({super.key});

  @override
  State<LoginApp> createState() => LoginAppState();
}

class LoginAppState extends State<LoginApp> {
  bool isLogged = false;
  late User user;
  late List<Meal> mealList;
  late List<UserDayEntry> initialList;
  late List<ProductsInMeal> productsinmeal;

  void _handleLogin(bool logged,User data, List<Meal> mealList, List<UserDayEntry> initialList, List<ProductsInMeal> productsinmeal) {
    setState(() {
      isLogged = logged;
      user = data;
      this.mealList = mealList;
      this.initialList = initialList;
      this.productsinmeal = productsinmeal;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDay = DateTime.now();
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[700],
        fontFamily: 'Georgia',
        
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginView(isLoggedCallback: _handleLogin),
        '/register': (context) => RegisterNowView(),
        '/forgotpassword': (context) => ForgotPasswordView(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/mainView') {
          // Przekierowanie do MyApp tylko jeśli użytkownik jest zalogowany
          if (isLogged) {

            return MaterialPageRoute(builder: (context) => MyApp(user: user, mealList: mealList, date: currentDay, initialList: initialList, productsinmeal: productsinmeal));
          }
        }
        return null;
      },
    );
  }
}