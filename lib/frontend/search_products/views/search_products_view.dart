import 'package:flutter/material.dart';
import '../view_models/search_products_view_model.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/user.dart';
import '../../../business_logic/delegates/search_products_delegate.dart';
import '../../../business_logic/provider-architecture/date_provider.dart';

class SearchProductsView extends StatefulWidget {
  final Meal meal;
  final DateProvider dateProvider;
  final User user;

  const SearchProductsView({
    super.key,
    required this.meal,
    required this.dateProvider,
    required this.user,
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
                delegate: SearchProductsDelegate(viewModel: viewModel),
              );
            },
          ),
        ],
      ),
      body: Container(),
    );
  }
}
