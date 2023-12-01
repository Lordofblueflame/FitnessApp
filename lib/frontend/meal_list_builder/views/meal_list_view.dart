import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_models/meal_list_view_model.dart';
import 'meal_container_view.dart';
import '../view_models/meal_container_view_model.dart';
import '../widgets/water_buttonbar_component.dart';
import '../../../business_logic/provider_architecture/water_intake_provider.dart';

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
    _calculationFuture = widget.viewModel.fetchProductsForView(widget.viewModel.productsInMeal);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var viewModel = Provider.of<MealsListViewModel>(context);
    _calculationFuture = viewModel.fetchProductsForView(viewModel.productsInMeal);
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
                create: (context) => WaterIntakeProvider(widget.viewModel.userProvider, widget.viewModel.dateProvider),
                child: const WaterButtonBarComponent(),
              );
            }
            return ChangeNotifierProvider<MealContainerViewModel>(
              create: (context) => MealContainerViewModel(
                meal: widget.viewModel.meals[index],
                mealKcal: widget.viewModel.mealKcal[index],
                mealProductPair: widget.viewModel.mealProductPair, 
                dateProvider: widget.viewModel.dateProvider, 
                userProvider: widget.viewModel.userProvider,
              ),
              child: const MealContainerView(),
            );
          },
        );
      } else if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      } else {
        return const CircularProgressIndicator();
      }
    },
  );
}

}
