import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/add_product_button.dart';
import '../../search_products/views/search_products_view.dart';
import '../view_models/meal_container_view_model.dart';
import '../../../backend/data_models/product.dart';

class MealContainerView extends StatelessWidget {
  const MealContainerView({super.key});

  @override
  Widget build(BuildContext context) {
    
    MealContainerViewModel viewModel = Provider.of<MealContainerViewModel>(context, listen: true);
    
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        unselectedWidgetColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        initiallyExpanded: viewModel.isExpanded,
        title: Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen[500],
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.elliptical(25, 10),
              right: Radius.elliptical(25, 10),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  viewModel.meal.mealName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
              ),
              Text(
                '${viewModel.mealKcal} kcal',
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 16,
                ),
              ),
              AddProductButton(
                onTap: () => _navigateToAddProduct(context, viewModel),
                shape: BoxShape.circle,
              ),
            ],
          ),
        ),
        onExpansionChanged: (expanded) => viewModel.setExpanded(expanded),
        trailing: const SizedBox(),
        children: [
          _MealContent(
            viewModel: viewModel,
          ),
        ],
      ),
    );
  }

  void _navigateToAddProduct(BuildContext context, MealContainerViewModel viewModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchProductsView(
          meal: viewModel.meal,
          dateProvider: viewModel.dateProvider,
          user: viewModel.userProvider.user!, 
          mealContainerViewModel: viewModel,
        ),
      ),
    ).then((_) {
      // If you need to do something when coming back from the SearchProductsView
      // like refreshing the state, you can call viewModel methods here.
    });
  }
}

class _MealContent extends StatelessWidget {
  final MealContainerViewModel viewModel;

  const _MealContent({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    List<Product> products = viewModel.getProductsForMeal();

    return viewModel.isExpanded
        ? Container(
            decoration: BoxDecoration(
              color: Colors.lightGreen[600],
              border: Border.all(color: Colors.black),
              borderRadius: const BorderRadius.horizontal(
                left: Radius.elliptical(25, 10),
                right: Radius.elliptical(25, 10),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: SingleChildScrollView(
              child: Column(
                children: products.map((product) {
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      tileColor: Colors.lightGreen[500],
                      title: Text(
                        product.productName,
                      ),
                      subtitle: Text(
                        '${product.calories} kcal',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _updateProduct(context, product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeProduct(context, product),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  void _updateProduct(BuildContext context, Product product) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => SearchProductsView(
        meal: viewModel.meal,
        dateProvider: viewModel.dateProvider,
        user: viewModel.userProvider.user!,
        productToUpdate: product, 
        mealContainerViewModel: viewModel,
      ),
    ),
  ).then((updatedProduct) {
    if (updatedProduct != null) {
      viewModel.updateProduct(product, updatedProduct);
    }
  });
  }

  void _removeProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Remove Product'),
          content: Text('Are you sure you want to remove ${product.productName}?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Remove'),
              onPressed: () {
                viewModel.removeProduct(product);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

