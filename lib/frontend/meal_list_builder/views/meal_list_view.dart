import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/meal_list_view_model.dart';
import '../widgets/meal_container_component.dart';
import '../widgets/water_buttonbar_component.dart';
import '../../../business_logic/provider-architecture/water_intake_provider.dart';

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
  void didChangeDependencies() {
    super.didChangeDependencies();
    var viewModel = Provider.of<MealsListViewModel>(context);
    _calculationFuture = viewModel.calculateMealKcals(viewModel.productsInMeal);
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
                return ChangeNotifierProvider(
                    create: (context) =>WaterIntakeProvider(widget.viewModel.userProvider, widget.viewModel.date),
                    child: const WaterButtonBarComponent()
                );
              }
              return MealContainerComponent(
                meal: widget.viewModel.meals[index],
                mealKcal: widget.viewModel.mealKcal[index],
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
