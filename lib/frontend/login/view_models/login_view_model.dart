import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/meal_api.dart';
import '../../../backend/api/products_in_meal_api.dart';
import '../../../backend/data_models/day_entries.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';

class LoginViewModel {
  final BuildContext context;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final Function(bool, List<Meal>, List<UserDayEntry>, List<ProductsInMeal>) isLoggedCallback;

  LoginViewModel(this.context, this.isLoggedCallback);

  Future<void> login() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    bool retval = await userProvider.loginUser(usernameController.text, passwordController.text);
    if (retval) {
      List<Meal> mealList = await getMeals();                   
      await userProvider.getUserInfoByUsernameAndPassword(usernameController.text, passwordController.text);
      
      String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();

      List<UserDayEntry> initialList = await getCurrentDayEntries(currentDate, userProvider.user!.userId);
      
      List<ProductsInMeal> productsInMeal = await getProductInMealFromDayEntries(initialList); 
      
      isLoggedCallback(true, mealList, initialList, productsInMeal);
      
      Navigator.pushReplacementNamed(context, '/mainPageView');
    } else {
      showDialog(                     
        context: context, 
        builder: (BuildContext context) => const AlertDialog(
          title: Text('Cannot login'),
          content: Text("You've provided the wrong username or password"),
        )
      );
    }
  }

  void navigateToForgotPassword() {
    Navigator.pushReplacementNamed(context, '/forgotPassword');
  }

  void navigateToRegister() {
    Navigator.pushReplacementNamed(context, '/register');
  }
}
