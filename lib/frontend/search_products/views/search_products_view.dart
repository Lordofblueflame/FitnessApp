import 'package:flutter/material.dart';
import '../view_models/search_products_view_model.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/user.dart';
import '../../../business_logic/delegates/search_products_delegate.dart';
import '../../../business_logic/provider_architecture/date_provider.dart';
import '../../meal_list_builder/view_models/meal_container_view_model.dart';
import '../../../backend/data_models/product.dart';

class SearchProductsView extends StatefulWidget {
  final Meal meal;
  final DateProvider dateProvider;
  final User user;
  final MealContainerViewModel mealContainerViewModel;
  final Product? productToUpdate; 

  const SearchProductsView({
    super.key,
    required this.meal,
    required this.dateProvider,
    required this.user,
    required this.mealContainerViewModel,
    this.productToUpdate,
  });

  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {
  late SearchProductsViewModel viewModel;

  @override
  void initState() {
    super.initState();
    viewModel = SearchProductsViewModel(
      meal: widget.meal,
      dateProvider: widget.dateProvider,
      user: widget.user,
      mealContainerViewModel: widget.mealContainerViewModel,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/mainPageView');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SearchProductsDelegate(viewModel: viewModel,productToUpdate: widget.productToUpdate),
              );
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
