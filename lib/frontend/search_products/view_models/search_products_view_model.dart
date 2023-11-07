// ViewModel for SearchProductsView: Contains business logic for search operations
import 'package:intl/intl.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/user.dart';
import '../../../backend/data_models/product.dart';
import '../../../backend/api/products_in_meal_api.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/product_api.dart';

class SearchProductsViewModel {
  final Meal meal;
  final DateTime date;
  final User user;

  SearchProductsViewModel({
    required this.meal,
    required this.date,
    required this.user,
  });

  Future<List<Product>> searchProducts(String query) async {
    return await searchForProducts(query);
  }

  Future<void> addProductToMeal(Product product) async {
    int newProductsInMealId = await addProductInMeal(meal.mealId, product.productId);
    Map<String, dynamic> data = {
      'user_id': user.userId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'water': 0,
      'workout': 0,
      'product_in_meal': newProductsInMealId,
    };
    await addNewEntry(data);
  }
}
