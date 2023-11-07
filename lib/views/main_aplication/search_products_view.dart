import '../../api/day_entries_api.dart';
// ignore: unused_import
import '../../api/meal_api.dart';
import '../../api/product_api.dart';
import '../../api/products_in_meal_api.dart';
import '../../components/product_found_component.dart';
import '../../data_models/meal.dart';
import '../../data_models/product.dart';
import '../../data_models/user.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SearchProductsView extends StatefulWidget {

  final Meal meal;
  final DateTime date;
  final User user;
  const SearchProductsView({super.key, required this.meal, required this.date, required this.user});
  @override
  State<SearchProductsView> createState() => _SearchProductsViewState();
}

class _SearchProductsViewState extends State<SearchProductsView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/mainView'); // Powrót do poprzedniego widoku
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
               delegate: MySearchDelegate(meal: widget.meal, date: widget.date, user: widget.user),
              );
            }
          )
        ],
      ),
      body: Container(),
    );
  }
}

class MySearchDelegate extends SearchDelegate{

  final Meal meal;
  final DateTime date;
  final User user;
  MySearchDelegate({required this.meal, required this.date, required this.user});

  List<String> searchResults = [
    'mleko',
    'mięso',
    'warzywo'
  ];

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      onPressed: () {
        if(query.isEmpty){
          close(context,null);
        }
        else{
          query = '';
        }
      }, 
      icon: const Icon(Icons.clear)
    )
  ];

  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    onPressed: () => close(context,null), 
    icon: const Icon(Icons.arrow_back),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where(
      (searchResults) {
        final result = searchResults.toLowerCase();
        final input = query.toLowerCase();

        return result.contains(input);
      }).toList();
    
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;

            showResults(context);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: searchForProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('An error occurred'));
        } else {
          final List<Product> products = snapshot.data ?? [];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final Product product = products[index];

              return GestureDetector(
                onTap: () {

                  _handleProductClick(product);
                },
                child: ProductFoundComponent(
                  product: product,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _handleProductClick(Product product) async {
    
    int newProductsInMealId = await addProductInMeal(meal.mealId,product.product_id);
    Map<String, dynamic> data = {
      'user_id': user.userId,
      'date': DateFormat('yyyy-MM-dd').format(date),
      'water': 0,
      'workout': 0,
      'product_in_meal': newProductsInMealId,
    };
    await addNewEntry(data);


  }
}