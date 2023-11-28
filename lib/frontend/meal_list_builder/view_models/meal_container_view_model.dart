import 'package:flutter/material.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/product.dart';
import '../../../backend/data_structures/pair_list.dart';
import '../../../business_logic/provider_architecture/user_provider.dart';
import '../../../business_logic/provider_architecture/date_provider.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/products_in_meal_api.dart';

class MealContainerViewModel with ChangeNotifier {
  final Meal meal;
  int mealKcal;
  final PairList<Meal, Product> mealProductPair;
  final DateProvider dateProvider;
  final UserProvider userProvider; 
  bool isExpanded = false; 

  MealContainerViewModel({
    required this.meal,
    required this.mealKcal,
    required this.mealProductPair,
    required this.dateProvider,
    required this.userProvider,
  });

  List<Product> getProductsForMeal() {
    return mealProductPair.getAllPairsForFirst(meal)
        .map((pair) => pair.second)
        .toList();
  }

  void addProduct(Product product) {
    mealProductPair.add(meal, product);
    mealKcal += product.calories;

    notifyListeners();
  }

  void removeProduct(Product product) async {
    mealKcal -= product.calories;
    mealProductPair.remove(meal,product);
    int productInMeal = await addProductInMeal(meal.mealId, product.productId);
    int entryId = await findDayEntry(userProvider.user!.userId, dateProvider.getSimpleDate(), productInMeal);

    await removeDayEntry(entryId);
    notifyListeners();
  }

  void updateProduct(Product oldProduct, Product newProduct) {
    int index = mealProductPair.find(meal, oldProduct);

    mealProductPair.set(index,meal,newProduct);
    
    notifyListeners();
  }

  void setExpanded(bool expanded) {
    isExpanded = expanded;
    
    notifyListeners();
  }
}
