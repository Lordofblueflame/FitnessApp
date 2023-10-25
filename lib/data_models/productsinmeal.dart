class ProductsInMeal {
  final int productsInMeal;
  final int mealId;
  final int productId;

  ProductsInMeal({
    required this.productsInMeal,
    required this.mealId,
    required this.productId,
  });

  factory ProductsInMeal.fromJson(Map<String, dynamic> json) {
    return ProductsInMeal(
      productsInMeal: json['products_in_meal'],
      mealId: json['meal_id'],
      productId: json['product_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'products_in_meal': productsInMeal,
      'meal_id': mealId,
      'product_id': productId,
    };
  }
}
