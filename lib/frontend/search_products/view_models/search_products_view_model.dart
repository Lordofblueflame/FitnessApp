import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/user.dart';
import '../../../backend/data_models/product.dart';
import '../../../backend/api/products_in_meal_api.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/product_api.dart';
import '../../../business_logic/provider_architecture/date_provider.dart';
import '../../meal_list_builder/view_models/meal_container_view_model.dart';

class SearchProductsViewModel {
  final Meal meal;
  final DateProvider dateProvider;
  final User user;
  final MealContainerViewModel mealContainerViewModel;

  SearchProductsViewModel({
    required this.meal,
    required this.dateProvider,
    required this.user,
    required this.mealContainerViewModel,
  });

  Future<List<Product>> searchProducts(String query) async {
    return await searchForProducts(query);
  }

  Future<void> updateProductInMealChangeDayEntry(Product oldProduct, Product newProduct) async {
    int newProductsInMealId = await addProductInMeal(meal.mealId, newProduct.productId);
    int oldProductsInMealId = await addProductInMeal(meal.mealId, oldProduct.productId);

    int dayEntryId = await findDayEntry(user.userId, dateProvider.getSimpleDate(),oldProductsInMealId);

    await updateDayEntry(dayEntryId, newProductsInMealId);
    mealContainerViewModel.updateProduct(oldProduct, newProduct);
  }

  Future<void> addProductToMeal(Product product) async {
    int newProductsInMealId = await addProductInMeal(meal.mealId, product.productId);

    await addNewEntry(user.userId,dateProvider.getSimpleDate(),0,0,newProductsInMealId);
  }
}
