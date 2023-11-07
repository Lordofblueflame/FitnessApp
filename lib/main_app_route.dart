import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'backend/data_models/day_entries.dart';
import 'backend/data_models/meal.dart';
import 'backend/data_models/products_in_meal.dart';
import 'business_logic/provider-architecture/user_provider.dart';
import 'frontend/main_page/views/main_page_view.dart';
import 'frontend/user_profile/change_parameters_view.dart';
import 'frontend/user_profile/change_password_view.dart';
import 'frontend/user_profile/userprofile_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.mealList,
    required this.date,
    required this.initialList,
    required this.productsinmeal,
  });

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
      initialRoute: '/mainPageView',
      routes: {
        '/mainPageView': (context) => MainPageView(
                                          initialDate: date, 
                                          mealList: mealList,
                                          userProvider: Provider.of<UserProvider>(context, listen: false)),
        '/userProfile': (context) => const UserProfileView(),
        '/changeParameters': (context) => ChangeParametersView(),
        '/changePassword': (context) => ChangePasswordView(),
      },
    );
  }
}
