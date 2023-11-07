import 'package:flutter/material.dart';
import '../../frontend/search_products/view_models/search_products_view_model.dart';
import '../../backend/data_models/product.dart';
import '../../frontend/search_products/widgets/product_found_widget.dart';

class SearchProductsDelegate extends SearchDelegate {
  final SearchProductsViewModel viewModel;

  SearchProductsDelegate({required this.viewModel});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = '';
          }
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [
      'mleko',
      'mięso',
      'warzywo',
    ].where((searchResult) {
      final result = searchResult.toLowerCase();
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
      future: viewModel.searchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found.'));
        } else {
          final List<Product> products = snapshot.data!;
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () {
                  _handleProductClick(context, product);
                },
                child: ProductFoundWidget(
                  product: product,
                ),
              );
            },
          );
        }
      },
    );
  }

  void _handleProductClick(BuildContext context, Product product) async {
    await viewModel.addProductToMeal(product);
    // This is where you might want to give feedback to the user, like a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${product.productName} to meal.')),
    );
    close(context, null); // This will close the search delegate and return to the previous screen
  }
}