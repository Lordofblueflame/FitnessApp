import 'package:flutter/material.dart';
import '../../../backend/data_models/meal.dart';
import '../view_models/meal_list_view_model.dart';
import '../widgets/meal_container_component.dart';
import '../widgets/water_buttonbar_component.dart';

class MealsListView extends StatefulWidget {
  final MealsListViewModel viewModel;

  const MealsListView({
    super.key,
    required this.viewModel,
  });

  @override
  _MealsListViewState createState() => _MealsListViewState();
}

class _MealsListViewState extends State<MealsListView> {
  late Future<void> _calculationFuture;

  @override
  void initState() {
    super.initState();
    _calculationFuture = widget.viewModel.calculateMealKcals(widget.viewModel.productsInMeal);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _calculationFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: widget.viewModel.meals.length + 1,
            itemBuilder: (context, index) {
              if (index == widget.viewModel.meals.length) {
                return WaterButtonBarComponent(
                  initialWater: widget.viewModel.initialWater,
                  neededWater: widget.viewModel.calculateWaterIntake(),
                  date: widget.viewModel.date,
                  user: widget.viewModel.userProvider.user!,
                );
              }
              final Meal meal = widget.viewModel.meals[index];
              final int mealKcalValue = widget.viewModel.mealKcal[index];

              return MealContainerComponent(
                meal: meal,
                mealKcal: mealKcalValue,
                date: widget.viewModel.date,
                user: widget.viewModel.userProvider.user!,
                key: UniqueKey(),
              );
            },
          );
        }  else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
