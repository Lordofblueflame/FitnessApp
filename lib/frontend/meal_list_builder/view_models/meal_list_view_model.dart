import 'package:flutter/material.dart';
import '../../../backend/data_models/meal.dart';
import '../../../business_logic/provider_architecture/user_provider.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../backend/api/product_api.dart';
import '../../../business_logic/provider_architecture/date_provider.dart';
import '../../../backend/data_models/product.dart';
import '../../../backend/data_structures/pair_list.dart';

class MealsListViewModel extends ChangeNotifier {
  final List<Meal> meals;
  final UserProvider userProvider;
  final DateProvider dateProvider;
  List<int> mealKcal = List.filled(5, 0, growable: true);
  int initialWater = 0;
  final List<ProductsInMeal> productsInMeal;
  late PairList<Meal,Product> mealProductPair = PairList(Meal,Product);

  MealsListViewModel({
    required this.meals,
    required this.userProvider,
    required this.dateProvider,
    required this.productsInMeal
  });

  Future<void> fetchProductsForView(List<ProductsInMeal> productsInMeal) async {
    for (var i = 0; i < meals.length; i++) {
      int totalKcal = 0;
      for (final productInMeal in productsInMeal) {
        if (productInMeal.mealId == meals[i].mealId) {
          final product = await getProductById(productInMeal.productId);
          totalKcal += product.calories;
          mealProductPair.add(meals[i],product);
        }
      }
      mealKcal[i] = totalKcal;
    }
  }


}
