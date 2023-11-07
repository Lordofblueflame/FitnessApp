import 'package:intl/intl.dart';
import '../../api/day_entries_api.dart';
import '../../api/product_api.dart';

// ignore: unused_import
import '../../data_models/user.dart';
import '../../components/meal_container_component.dart';
import '../../components/water_buttonbar_component.dart';
import '../../data_models/meal.dart';
import '../../data_models/productsinmeal.dart';
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import '../../data_models/dayentries.dart';


class MealsListBuilder extends StatefulWidget {
  final List<Meal> meals;
  final DateTime date;
  final UserProvider userProvider;
  final List<ProductsInMeal> productsinmeal;

  const MealsListBuilder({
    Key? key,
    required this.meals,
    required this.date,
    required this.userProvider,
    required this.productsinmeal,
  }) : super(key: key);

  @override
  _MealsListBuilderState createState() => _MealsListBuilderState();
}


class _MealsListBuilderState extends State<MealsListBuilder> {
  late List<int> mealKcal = [0,0,0,0,0];
  late Future<void> _calculationFuture;
  late int initialWater = 0;

  @override
  void initState() {
    super.initState();
    _calculationFuture = calculateMealKcals();
  }

  Future<List<UserDayEntry>> getDayEntriesWithWater() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(widget.date);
    List<UserDayEntry> dayEntries = await getCurrentDayEntries(formattedDate, widget.userProvider.user!.userId); 
    return dayEntries.where((entry) {
      return DateFormat('yyyy-MM-dd').format(widget.date) == formattedDate && entry.water == initialWater;
    }).toList();
  }

  Future<void> calculateMealKcals() async {
    List<int> changes = [];
    
    final productsinmealCopy = List<ProductsInMeal>.from(widget.productsinmeal);

    for (final meal in widget.meals) {
      int totalKcal = 0;
      for (final productInMeal in productsinmealCopy) {
        if (productInMeal.mealId == meal.mealId) {
          final product = await getProductById(productInMeal.productId);
          totalKcal += product.calories;
        }
      }
      changes.add(totalKcal);
    }
    setState(() {
      mealKcal = changes;
    });
  }

  @override
  void didUpdateWidget(MealsListBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.productsinmeal != oldWidget.productsinmeal) {
      calculateMealKcals();
    }
  }

  int calcWater() {
    return widget.userProvider.user!.weight * 35;
  }

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<void>(
      future: _calculationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.meals.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.meals.length) {
                return WaterButtonBarComponent(
                  initialWater: initialWater,
                  neededWater: calcWater(),
                  date: widget.date,
                  user: widget.userProvider.user!,
                );
              }
              final Meal meal = widget.meals[index];
              final int mealKcalValue = mealKcal[index];

              return MealContainerComponent(
                meal: meal,
                mealKcal: mealKcalValue,
                date: widget.date,
                user: widget.userProvider.user!,
                key: UniqueKey(),
              );
            },
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
