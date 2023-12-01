import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/add_product_button.dart';
import '../../search_products/views/search_products_view.dart';
import '../view_models/meal_container_view_model.dart';
import '../../../backend/data_models/product.dart';

class MealContainerView extends StatelessWidget {
  const MealContainerView({super.key});

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

    });
  }

  @override
  Widget build(BuildContext context) {
    final MealContainerViewModel viewModel = Provider.of<MealContainerViewModel>(context);

    return Container( 
        decoration: BoxDecoration(
        color: Colors.lightGreen[500],
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.horizontal(
          left: Radius.elliptical(30, 20),
          right: Radius.elliptical(30, 20),
        ),
      ),
      child: ExpansionTile(       
        initiallyExpanded: viewModel.isExpanded,
        trailing: const SizedBox(),
        title: Row(
              children: [
                Column(
                  children:[
                    SizedBox(
                      width: 150,
                      child: Text(
                        viewModel.meal.mealName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                        ),
                      ),
                    ),
                    Container(
                      transform: Matrix4.translationValues(-30,3,0),
                      width: 80,
                      child: Text(
                        '${viewModel.mealKcal} kcal',
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ]
                ),
                const SizedBox(width: 20),
                Container(
                  transform: Matrix4.translationValues(120, 0, 0),
                  child: AddProductButton(
                    onTap: () => _navigateToAddProduct(context, viewModel),
                    shape: BoxShape.circle,
                  ),
                ),              
              ],
            ),   

        onExpansionChanged: (bool expanded) => viewModel.setExpanded(expanded),
        children: [
          _MealContent(viewModel: viewModel),
        ],
      ),
    );
  }
}

class _MealContent extends StatelessWidget {
  final MealContainerViewModel viewModel;

  const _MealContent({required this.viewModel});

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

  @override
  Widget build(BuildContext context) {
    List<Product> products = viewModel.getProductsForMeal();

    return viewModel.isExpanded
        ? Column(
                children: products.map((product) {
                  return Container(
                      decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 125, 215, 80),
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.horizontal(
                        left: Radius.elliptical(30, 20),
                        right: Radius.elliptical(30, 20),
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 2,left: 2, right: 2,top: 5),
                    child: ListTile(                    
                      tileColor: Colors.green[500],
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
              )              
        : const SizedBox.shrink();
  }
}

