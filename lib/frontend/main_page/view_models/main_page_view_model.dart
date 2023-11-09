import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../../../backend/api/day_entries_api.dart';
import '../../../backend/api/product_api.dart';
import '../../../backend/data_models/day_entries.dart';
import '../../../backend/data_models/macro_data.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';
import '../../../backend/api/products_in_meal_api.dart';

class MainPageViewModel extends ChangeNotifier {
  final UserProvider userProvider;
  late MacroData _needed = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
  MacroData _total = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
  late double _userBmi = 0;
  List<ProductsInMeal> _todayProductsInMeal = [];
  DateTime _selectedDate;

  MainPageViewModel({
    required this.userProvider,
    required DateTime selectedDate,
  }) : _selectedDate = selectedDate {
    _initializeData();
    notifyListeners();
  }

  MacroData get needed => _needed;
  MacroData get total => _total;
  double get userBmi => _userBmi;
  List<ProductsInMeal> get todayProductsInMeal => _todayProductsInMeal;
  DateTime get selectedDate => _selectedDate;

  void _initializeData() async {
    await updateData(_selectedDate);
    _userBmi = calculateBMI(userProvider.user!.weight, userProvider.user!.height);
    _needed = calculateNeededMacros(_userBmi);
    notifyListeners();
  }

  Future<void> updateData(DateTime date) async {
    try {
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);
      List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, userProvider.user!.userId);
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
    _selectedDate = date;
    updateData(date).then((_) {
      notifyListeners();
    });
  }
}
