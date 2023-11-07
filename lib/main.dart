import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'data_models/dayentries.dart';
import 'data_models/meal.dart';
import 'data_models/productsinmeal.dart';
import 'main_app_route.dart';
import 'views/login_related/forgot_password_view.dart';
import 'views/login_related/login_view.dart';
import 'views/login_related/register_view.dart';
import 'repositories/user_repository.dart';

void main() {
  runApp(const LoginApp());
}

class LoginApp extends StatefulWidget {
  const LoginApp({Key? key}) : super(key: key);

  @override
  State<LoginApp> createState() => LoginAppState();
}

class LoginAppState extends State<LoginApp> {
  bool isLogged = false;
  late List<Meal> mealList;
  late List<UserDayEntry> initialList;
  late List<ProductsInMeal> productsinmeal;

  void _handleLogin(bool logged, List<Meal> mealList,
      List<UserDayEntry> initialList, List<ProductsInMeal> productsinmeal) {
    setState(() {
      isLogged = logged;
      this.mealList = mealList;
      this.initialList = initialList;
      this.productsinmeal = productsinmeal;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime currentDay = DateTime.now();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(UserRepository()),
        ),

      ],
      child: MaterialApp(
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
            if (isLogged) {

              return MaterialPageRoute(
                builder: (context) => MyApp(
                  mealList: mealList,
                  date: currentDay,
                  initialList: initialList,
                  productsinmeal: productsinmeal,
                ),
              );
            }
          }
          return null;
        },
      ),
    );
  }
}
