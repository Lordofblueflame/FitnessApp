import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/user.dart';
import '../../../backend/data_models/product.dart';
import '../../../backend/api/products_in_meal_api.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/product_api.dart';
import '../../../business_logic/provider-architecture/date_provider.dart';

class SearchProductsViewModel {
  final Meal meal;
  final DateProvider dateProvider;
  final User user;

  SearchProductsViewModel({
    required this.meal,
    required this.dateProvider,
    required this.user,
  });

  Future<List<Product>> searchProducts(String query) async {
    return await searchForProducts(query);
  }

  Future<void> addProductToMeal(Product product) async {
    int newProductsInMealId = await addProductInMeal(meal.mealId, product.productId);

    await addNewEntry(user.userId,dateProvider.getSimpleDate(),0,0,newProductsInMealId);
  }
}
