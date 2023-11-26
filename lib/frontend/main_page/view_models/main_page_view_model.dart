import 'package:flutter/foundation.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/product_api.dart';
import '../../../backend/data_models/day_entries.dart';
import '../../../backend/data_models/macro_data.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';
import '../../../backend/api/products_in_meal_api.dart';
import '../../../business_logic/provider-architecture/date_provider.dart';

class MainPageViewModel extends ChangeNotifier {
  final UserProvider userProvider;
  late MacroData _needed = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
  MacroData _total = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
  late double _userBmi = 0;
  List<ProductsInMeal> _todayProductsInMeal = [];
  final DateProvider _dateProvider;

  MainPageViewModel({
    required this.userProvider,
    required DateProvider dateProvider,
  }) : _dateProvider = dateProvider {
    _initializeData();
    notifyListeners();
  }

  MacroData get needed => _needed;
  MacroData get total => _total;
  double get userBmi => _userBmi;
  List<ProductsInMeal> get todayProductsInMeal => _todayProductsInMeal;
  DateProvider get dateProvider => _dateProvider;

  void _initializeData() async {
    await updateData(_dateProvider.date);
    _userBmi = calculateBMI(userProvider.user!.weight, userProvider.user!.height);
    _needed = calculateNeededMacros(_userBmi);
    notifyListeners();
  }

  Future<void> updateData(DateTime date) async {
    try {
      _dateProvider.setDate(date);
      
      List<UserDayEntry> dayEntries = await getCurrentDayEntries(_dateProvider.getSimpleDate(), userProvider.user!.userId);
      List<ProductsInMeal> productsInMeal = await getProductInMealFromDayEntries(dayEntries);
      MacroData totalFromProducts = await calculateTotalFromProducts(productsInMeal);

      _todayProductsInMeal = productsInMeal;
      _total = totalFromProducts;

      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred while updating data: $e');
      }
    }
  }

  Future<MacroData> calculateTotalFromProducts(List<ProductsInMeal> productsInMeal) async {
    MacroData totalFromProduct = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
    for (final productInMeal in productsInMeal) {
      final product = await getProductById(productInMeal.productId);
      totalFromProduct.kcal += product.calories;
      totalFromProduct.proteins += product.proteins;
      totalFromProduct.fats += product.fats;
      totalFromProduct.carbs += product.carbs;
    }
    return totalFromProduct;
  }

  MacroData calculateNeededMacros(double bmi) {
    int kcal = (bmi <= 18.5) ? 1800 : (bmi >= 30) ? 2200 : 2000;
    return MacroData(
      kcal: kcal,
      proteins: ((kcal / 9 * 0.55)).roundToDouble(),
      fats: ((kcal / 4 * 0.20)).roundToDouble(),
      carbs: ((kcal / 4 * 0.25)).roundToDouble(),
    );
  }

  double calculateBMI(int weight, int height) {
    double heightInMeters = height / 100;
    return weight / (heightInMeters * heightInMeters);
  }

  void handleDateSelected(DateTime date) {
    _dateProvider.setDate(date);
    updateData(_dateProvider.date).then((_) {
      notifyListeners();
    });
  }
}
