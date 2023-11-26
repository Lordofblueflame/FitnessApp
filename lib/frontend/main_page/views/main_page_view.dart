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
import '../../../business_logic/provider-architecture/date_provider.dart';

class MainPageView extends StatelessWidget {
  final List<Meal> mealList;
  final UserProvider userProvider;

  const MainPageView({
    super.key,
    required this.mealList,
    required this.userProvider,
  });

  @override
  Widget build(BuildContext context) {
    DateProvider dateProvider = Provider.of<DateProvider>(context, listen: false);
    return ChangeNotifierProvider(
      create: (_) => MainPageViewModel(
        userProvider: userProvider,
        dateProvider: dateProvider,
      ),
      child: Consumer<MainPageViewModel>(
        builder: (context, viewModel, child) {
            var mealsListViewModel = MealsListViewModel(
            meals: mealList,
            dateProvider: viewModel.dateProvider,
            userProvider: userProvider,
            productsInMeal: List<ProductsInMeal>.from(viewModel.todayProductsInMeal),
          );
          return Scaffold(
            backgroundColor: Colors.green[700],
            appBar: AppBar(
              flexibleSpace: const HeaderWidget(),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(0.0),
                child: DayButton(
                  restorationId: "1",
                  initialDate: dateProvider.date,
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
                ChangeNotifierProvider.value(
                  value: mealsListViewModel,
                  child: MealsListView( viewModel: mealsListViewModel,
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