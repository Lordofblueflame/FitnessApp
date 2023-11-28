import 'dart:convert';
import '../data_models/day_entries.dart';
import '../data_models/products_in_meal.dart';
import 'package:http/http.dart' as http;
import 'common_api.dart';
import '../log/debug_helper.dart';

Future<int> addProductInMeal(int mealId, int productId) async {
  DebugHelper.printFunctionName();

  final Uri url = Uri.parse('$address/productinmeal/addproductinmeal');

  final Map<String, dynamic> data = {
    'meal_id': mealId,
    'product_id': productId,
  };

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final int productsInMeal = jsonResponse['products_in_meal'] as int;
    return productsInMeal;
  } else {
    throw Exception('Error adding product to meal: ${response.statusCode}');
  }
}

Future<ProductsInMeal> getProductInMeal(int productInMealId) async {
  DebugHelper.printFunctionName();

  final Uri url = Uri.parse('$address/productinmeal/getproductinmeal?productinmeal=$productInMealId');

  final response = await http.get(url);
  
  if (response.statusCode == 200) {
     final jsonResponse = jsonDecode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      final productJson = jsonResponse.first;
      final productsInMeal = ProductsInMeal.fromJson(productJson);
      return productsInMeal;
    } 
  } else {
    throw Exception('Error fetching product from meal: ${response.statusCode}');
  }
   throw Exception('Error fetching product from meal: ${response.statusCode}');
}

Future<List<ProductsInMeal>> getProductInMealFromDayEntries(List<UserDayEntry> dayEntries) async {
  DebugHelper.printFunctionName();

  final List<ProductsInMeal> productsInMealList = [];

  for (final entry in dayEntries) {
      if (entry.productInMeal == null || entry.productInMeal == 0) {
        continue; 
      }

      final ProductsInMeal productsInMeal = await getProductInMeal(entry.productInMeal!);
      productsInMealList.add(productsInMeal);
    }

  return productsInMealList;
}