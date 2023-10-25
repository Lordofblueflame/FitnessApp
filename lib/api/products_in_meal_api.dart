import 'dart:convert';
import '../data_models/dayentries.dart';
import '../data_models/productsinmeal.dart';
import 'package:http/http.dart' as http;
import 'common_api.dart';

Future<int> addProductInMeal(int mealId, int productId) async {
  final Uri url = Uri.parse('$adres/productinmeal/addproductinmeal');

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
    throw Exception('Błąd podczas dodawania produktu do posiłku: ${response.statusCode}');
  }
}

Future<int> getProductInMealById(int productInMealId) async {
  final Uri url = Uri.parse('$adres/productinmeal/getproductinmealbyid?productinmeal=$productInMealId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    final ProductsInMeal productsInMeal = ProductsInMeal.fromJson(jsonResponse);
    return productsInMeal.productId;
  } else {
    throw Exception('Błąd podczas pobierania produktu z posiłku: ${response.statusCode}');
  }
}

Future<ProductsInMeal> getProductInMeal(int productInMealId) async {
  final Uri url = Uri.parse('$adres/productinmeal/getproductinmeal?productinmeal=$productInMealId');

  final response = await http.get(url);
  
  if (response.statusCode == 200) {
     final jsonResponse = jsonDecode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      final productJson = jsonResponse.first;
      final productsInMeal = ProductsInMeal.fromJson(productJson);
      return productsInMeal;
    } 
  } else {
    throw Exception('Błąd podczas pobierania produktu z posiłku: ${response.statusCode}');
  }
   throw Exception('Błąd podczas pobierania produktu z posiłku: ${response.statusCode}');
}

Future<List<ProductsInMeal>> getProductInMealFromDayEntries(List<UserDayEntry> dayEntries) async {
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