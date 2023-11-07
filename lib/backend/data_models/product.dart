class Product {
  final int productId;
  final String productName;
  final int calories;
  final double proteins;
  final double fats;
  final double carbs;

  Product({
    required this.productId,
    required this.productName,
    required this.calories,
    required this.proteins,
    required this.fats,
    required this.carbs,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      calories: json['calories'],
      proteins: json['proteins'].toDouble(),
      fats: json['fats'].toDouble(),
      carbs: json['carbons'].toDouble(),
    );
  }
}
