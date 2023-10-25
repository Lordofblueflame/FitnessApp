import '../../api/product_api.dart';
import '../../data_models/user.dart';
import '../../components/meal_container_component.dart';
import '../../components/water_buttonbar_component.dart';
import '../../data_models/meal.dart';
import '../../data_models/productsinmeal.dart';
import 'package:flutter/material.dart';

class MealsListBuilder extends StatefulWidget {
  final List<Meal> meals;
  final DateTime date;
  final User user;
  final List<ProductsInMeal> productsinmeal;

  const MealsListBuilder({super.key, 
    required this.meals,
    required this.date,
    required this.user,
    required this.productsinmeal,
  });

  @override
  _MealsListBuilderState createState() => _MealsListBuilderState();
}


class _MealsListBuilderState extends State<MealsListBuilder> {
  late List<int> mealKcal = [0,0,0,0,0];

  @override
  void initState() {
    calculateMealKcals();
    super.initState();
  }

  Future<void> calculateMealKcals() async {
    mealKcal = [];

    for (final meal in widget.meals) {
      int totalKcal = 0;
      for (final productInMeal in widget.productsinmeal) {
        if (productInMeal.mealId == meal.mealId) {
          final product = await getProductById(productInMeal.productId);
          totalKcal += product.calories;
        }
      }
      mealKcal.add(totalKcal);
    }
  }

  int calcWater() {
    return widget.user.weight * 35;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: calculateMealKcals(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.meals.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.meals.length) {
                return WaterButtonBarComponent(
                  water: 0,
                  neededWater: calcWater(),
                  date: widget.date,
                  user: widget.user,
                );
              }
              final Meal meal = widget.meals[index];
              final int mealKcalValue = mealKcal[index];

              return MealContainerComponent(
                meal: meal,
                mealKcal: mealKcalValue,
                date: widget.date,
                user: widget.user,
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
