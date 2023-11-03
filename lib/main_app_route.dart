// ignore: unused_import
import 'api/day_entries_api.dart';
import 'data_models/dayentries.dart';
import 'data_models/meal.dart';
import 'data_models/productsinmeal.dart';
import 'views/main_aplication/main_view.dart';
import 'views/userprofile/change_parameters_view.dart';
import 'views/userprofile/change_password_view.dart';
import 'views/userprofile/userprofile_view.dart';
import 'package:flutter/material.dart';
import 'providers/user_provider.dart';
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    required this.userProvider, // Make sure this parameter exists
    required this.mealList,
    required this.date,
    required this.initialList,
    required this.productsinmeal,
  }) : super(key: key);

  final UserProvider userProvider; // Add this parameter
  final List<Meal> mealList;
  final DateTime date;
  final List<UserDayEntry> initialList;
  final List<ProductsInMeal> productsinmeal;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.green[700],
        fontFamily: 'Georgia',
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.green
          ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
          titleLarge: TextStyle(fontSize: 36, fontStyle: FontStyle.italic),
        ),
      ),
      color: Colors.amber,
      highContrastTheme: ThemeData.light(),
      initialRoute: '/mainView',
      routes: {
        '/mainView': (context) => MainView(initialDate: date, mealList: mealList, user: user, initialList: initialList, productsinmeal:productsinmeal),
        '/userprofile': (context) => UserProfileView(thisUser: user),
        '/changeparameters': (context) => ChangeParametersView(user: user),
        '/changepassword': (context) => ChangePasswordView(userid: user.userId),
      },
    );
  }
}
