import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../api/day_entries_api.dart';
import '../../api/product_api.dart';
import '../../api/products_in_meal_api.dart';
import '../../components/buttons/day_button.dart';
import '../../components/header_component.dart';
import '../../components/kcal_footer_component.dart';
import '../../components/small_components/MealsListBuilder.dart';
import '../../data_models/dayentries.dart';
import '../../data_models/macrodata.dart';
import '../../data_models/meal.dart';
import '../../data_models/productsinmeal.dart';
import '../../providers/user_provider.dart';

// ignore: must_be_immutable
class MainView extends StatefulWidget {
  final DateTime initialDate;
  final List<Meal> mealList;
  final UserProvider userProvider;

  const MainView({
    Key? key,
    required this.initialDate,
    required this.mealList,
    required this.userProvider,
  }) : super(key: key);

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late MacroData needed;
  late MacroData total = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
  late double userBmi;
  late List<ProductsInMeal> todayProductsInMeal = [];
  late DateTime selectedDate = widget.initialDate;

  @override
  void initState() {
    super.initState();
    userBmi = calculateBMI(widget.userProvider.user!.weight, widget.userProvider.user!.height);
    needed = calculateNeededMacros(userBmi);
    updateData(widget.initialDate);
  }

  void initializeData() {
    userBmi = calculateBMI(widget.userProvider.user!.weight, widget.userProvider.user!.height);
    needed = calculateNeededMacros(userBmi);
    updateData(selectedDate);
  }

  Future<void> updateData(DateTime date) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, widget.userProvider.user!.userId);
    List<ProductsInMeal> productsInMeal = await getProductInMealFromDayEntries(dayEntries);
    MacroData totalFromProducts = await calculateTotalFromProducts(productsInMeal);

    setState(() {
      todayProductsInMeal = productsInMeal;
      total = totalFromProducts;
    });
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

  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      updateData(date);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[700],
      appBar: AppBar(
        flexibleSpace: const HeaderComponent(),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: DayButton(
            restorationId: "1",
            initialDate: selectedDate,
            onDateSelected: _handleDateSelected,
          ),
        ),
      ),
      bottomSheet: KcalFooterWidget(
        totalkcal: total.kcal,
        neededkcal: needed.kcal,
        totalprot: total.proteins,
        neededprot: needed.proteins,
        totalfats: total.fats,
        neededfats: needed.fats,
        totalcarbs: total.carbs,
        neededcarbs: needed.carbs,
      ),
      body: ListView(
        children: [
          MealsListBuilder(
            meals: widget.mealList,
            date: selectedDate,
            productsinmeal: List<ProductsInMeal>.from(todayProductsInMeal),
            userProvider: widget.userProvider,
          ),
        ],
      ),
    );
  }
}
