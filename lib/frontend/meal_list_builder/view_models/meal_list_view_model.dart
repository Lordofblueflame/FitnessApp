import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../backend/data_models/meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../backend/data_models/day_entries.dart';
import '../../../backend/api/product_api.dart';
import '../../../backend/api/day_entries_api.dart';

class MealsListViewModel extends ChangeNotifier {
  final List<Meal> meals;
  final UserProvider userProvider;
  final DateTime date;
  List<int> mealKcal = List.filled(5, 0, growable: true);
  int initialWater = 0;
  final List<ProductsInMeal> productsInMeal;

  MealsListViewModel({
    required this.meals,
    required this.userProvider,
    required this.date,
    required this.productsInMeal
  });

  Future<void> calculateMealKcals(List<ProductsInMeal> productsInMeal) async {
    for (var i = 0; i < meals.length; i++) {
      int totalKcal = 0;
      for (final productInMeal in productsInMeal) {
        if (productInMeal.mealId == meals[i].mealId) {
          final product = await getProductById(productInMeal.productId);
          totalKcal += product.calories;
        }
      }
      mealKcal[i] = totalKcal;
    }
  }

  int calculateWaterIntake() {
    return userProvider.user!.weight * 35;
  }

  Future<List<UserDayEntry>> filterDayEntriesWithWater() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, userProvider.user!.userId);
    return dayEntries.where((entry) => DateFormat('yyyy-MM-dd').format(date) == formattedDate && entry.water == initialWater).toList();
  }
}
