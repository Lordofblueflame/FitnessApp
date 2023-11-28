import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'business_logic/provider_architecture/user_provider.dart';
import 'backend/data_models/day_entries.dart';
import 'backend/data_models/meal.dart';
import 'backend/data_models/products_in_meal.dart';
import 'main_app_route.dart';
import 'frontend/login/views/forgot_password_view.dart';
import 'frontend/login/view_models/forgot_password_view_model.dart';
import 'frontend/login/views/login_view.dart';
import 'frontend/login/views/register_view.dart';
import 'frontend/login/view_models/register_view_model.dart';
import 'business_logic/provider_architecture/repositories/user_repository.dart';
import 'business_logic/provider_architecture/date_provider.dart';

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

    return MultiProvider(
providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(UserRepository())),
        ChangeNotifierProvider(create: (_) => DateProvider(DateTime.now())), // Use ChangeNotifierProvider
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
          '/register': (context) => ChangeNotifierProvider(
            create: (context) => RegisterViewModel() ,
            child: const RegisterView(),
          ),
          '/forgotPassword': (context) => ChangeNotifierProvider(
            create: (context) => ForgotPasswordViewModel(),
            child: const ForgotPasswordView(),
          )
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/mainPageView') {
            if (isLogged) {

              return MaterialPageRoute(
                builder: (context) => MyApp(
                  mealList: mealList,
                  dateProvider: Provider.of<DateProvider>(context, listen: false),
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
