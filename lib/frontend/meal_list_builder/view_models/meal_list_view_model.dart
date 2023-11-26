import 'package:flutter/material.dart';
import '../../../backend/data_models/meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../backend/api/product_api.dart';
import '../../../business_logic/provider-architecture/date_provider.dart';

class MealsListViewModel extends ChangeNotifier {
  final List<Meal> meals;
  final UserProvider userProvider;
  final DateProvider dateProvider;
  List<int> mealKcal = List.filled(5, 0, growable: true);
  int initialWater = 0;
  final List<ProductsInMeal> productsInMeal;

  MealsListViewModel({
    required this.meals,
    required this.userProvider,
    required this.dateProvider,
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
}
