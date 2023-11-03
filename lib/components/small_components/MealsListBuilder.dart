import '../../api/product_api.dart';
// ignore: unused_import
import '../../data_models/user.dart';
import '../../components/meal_container_component.dart';
import '../../components/water_buttonbar_component.dart';
import '../../data_models/meal.dart';
import '../../data_models/productsinmeal.dart';
import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';

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

  @override
  void initState() {
    super.initState();
    calculateMealKcals();
  }

  Future<void> calculateMealKcals() async {
    List<int> changes = [];

    for (final meal in widget.meals) {
      int totalKcal = 0;
      for (final productInMeal in widget.productsinmeal) {
        if (productInMeal.mealId == meal.mealId) {
          final product = await getProductById(productInMeal.productId);
          totalKcal += product.calories;
        }
      }
      changes.add(totalKcal);
    }
      mealKcal = changes;
  }

  int calcWater() {
    return widget.userProvider.user!.weight * 35;
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
