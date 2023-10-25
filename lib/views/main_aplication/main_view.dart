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
import '../../data_models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class MainView extends StatefulWidget {
  MainView({
    super.key,
    required this.initialDate,
    required this.mealList,
    required this.user,
    required this.initialList,
    required this.productsinmeal,
  });

  late DateTime initialDate;
  final User user;
  late List<UserDayEntry> initialList;
  late List<ProductsInMeal> productsinmeal;
  final List<Meal> mealList;

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late MacroData needed;
  late MacroData total;
  late double userBmi = 0;
  late List<ProductsInMeal> todayProductsInMeal = [];

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  @override
  void didUpdateWidget(MainView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      updateData();

    }
  }

  Future<void> _updateInitialList() async {
    List<UserDayEntry> updatedInitialList = await getUserDayEntries(widget.user.userId);

    setState(() {
      widget.initialList = updatedInitialList;
    });
  }

  Future<void> _updateProductsInMeal() async {
  List<ProductsInMeal> updatedProductsInMeal = await getProductInMealFromDayEntries(widget.initialList);

    setState(() {
      widget.productsinmeal = updatedProductsInMeal;
    });
  }

  void initializeData() {
    needed = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
    total = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);

    userBmi = calculateBMI(widget.user.weight, widget.user.height);
    if (userBmi <= 18.5) {
      needed.kcal = 1800;
    }

    if (userBmi >= 30) {
      needed.kcal = 2200;
    }

    if (userBmi > 18.5 && userBmi < 30) {
      needed.kcal = 2000;
    }

    needed.proteins = (((needed.kcal / 9 * 0.55))).roundToDouble();
    needed.fats = ((needed.kcal / 4 * 0.20)).roundToDouble();
    needed.carbs = ((needed.kcal / 4 * 0.25)).roundToDouble();

    updateData();
  }

  void updateData() async {
    todayProductsInMeal.clear();
    await _updateInitialList();
    await _updateProductsInMeal();
    MacroData totalFromProduct = MacroData(kcal: 0, proteins: 0, fats: 0, carbs: 0);
    final userDayEntriesForDate = widget.initialList.where((entry) {
      String foramtDate = DateFormat('yyyy-MM-dd').format(widget.initialDate);
      return entry.date == foramtDate;
    });
    
    for (final userDayEntry in userDayEntriesForDate) {
      final matchingProductsInMeal = widget.productsinmeal.where((productInMeal) =>
      productInMeal.productsInMeal == userDayEntry.productInMeal);

      if (matchingProductsInMeal.isNotEmpty) {
        for (final matchingProductInMeal in matchingProductsInMeal) {
          final product = await getProductById(matchingProductInMeal.productId);
          totalFromProduct.kcal += product.calories;
          totalFromProduct.proteins += product.carbs;
          totalFromProduct.fats += product.fats;
          totalFromProduct.carbs += product.proteins;
          todayProductsInMeal.add(matchingProductInMeal);
        }
      }
    }

    setState(() {
      total.kcal = totalFromProduct.kcal;
      total.carbs = totalFromProduct.carbs;
      total.fats = totalFromProduct.fats;
      total.proteins = totalFromProduct.proteins;
    });
  }

  double calculateBMI(int weight, int height) {
    double bmi = weight / (height * height);
    return bmi;
  }

  void _handleDateSelected(DateTime selectedDate) {
    setState(() {
      widget.initialDate = selectedDate;
      updateData();
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
          child: DayButton(restorationId: "1", initialDate: widget.initialDate, onDateSelected: _handleDateSelected),
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
          MealsListBuilder(meals: widget.mealList, date: widget.initialDate, user: widget.user, productsinmeal: todayProductsInMeal),
        ],
      ),
    );
  }
}
