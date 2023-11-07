import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../frontend/widgets/buttons/day_button.dart';
import '../widgets/header_widget.dart';
import '../widgets/kcal_footer_widget.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';
import '../view_models/main_page_view_model.dart'; 
import '../../meal_list_builder/views/meal_list_view.dart';
import '../../meal_list_builder/view_models/meal_list_view_model.dart';

class MainPageView extends StatelessWidget {
  final DateTime initialDate;
  final List<Meal> mealList;
  final UserProvider userProvider;

  const MainPageView({
    super.key,
    required this.initialDate,
    required this.mealList,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainPageViewModel(
        userProvider: userProvider,
        selectedDate: initialDate,
      ),
      child: Consumer<MainPageViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.green[700],
            appBar: AppBar(
              flexibleSpace: const HeaderWidget(),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: DayButton(
                  restorationId: "1",
                  initialDate: viewModel.selectedDate,
                  onDateSelected: (date) {
                    viewModel.updateData(date);
                  },
                ),
              ),
            ),
            bottomSheet: KcalFooterWidget(
              totalkcal: viewModel.total.kcal,
              neededkcal: viewModel.needed.kcal,
              totalprot: viewModel.total.proteins,
              neededprot: viewModel.needed.proteins,
              totalfats: viewModel.total.fats,
              neededfats: viewModel.needed.fats,
              totalcarbs: viewModel.total.carbs,
              neededcarbs: viewModel.needed.carbs,
            ),
            body: ListView(
              children: [
                MealsListView( 
                  viewModel: MealsListViewModel(
                  meals: mealList,
                  date: viewModel.selectedDate,
                  userProvider: userProvider,
                  productsInMeal: List<ProductsInMeal>.from(viewModel.todayProductsInMeal),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}