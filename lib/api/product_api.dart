// ignore: unused_import
import '../data_models/meal.dart';
import '../data_models/productsinmeal.dart';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_models/product.dart';
import 'common_api.dart';

Future<Product> getProductById(int id) async {
  final url = '$adres/product/getproduct?product_id=$id'; // Zmień adres na swój

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
           final jsonResponse = jsonDecode(response.body);
    if (jsonResponse is List && jsonResponse.isNotEmpty) {
      final productJson = jsonResponse.first;
      final product = Product.fromJson(productJson);
      return product;
    } 
    } else {
      throw Exception('Błąd podczas pobierania produktu: ${response.statusCode}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
    throw Exception('Wystąpił błąd podczas komunikacji z serwerem');
  }
   throw Exception('Wystąpił błąd podczas komunikacji z serwerem');
}

Future<List<Product>> getListOfProductsFromProductsInMeal(List<ProductsInMeal> productsinmeal) async {
  final List<Product> productList = [];

  for (final entry in productsinmeal) {
    final Product product = await getProductById(entry.productId);

    productList.add(product);
  }

  return productList;
}
//szukanie produktów podobnych do wpisanego GET
// ignore: non_constant_identifier_names
Future<List<Product>> searchForProducts(String productName) async {
  final url = '$adres/product/searchproductbyname?product_name=$productName'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};

  print(productName);
  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      final List<Product> productList = responseData.map((item) {
        final Map<String, dynamic> jsonMap = item;
        return Product(
          product_id: jsonMap['product_id'],
          productName: jsonMap['product_name'],
          calories: jsonMap['calories'],
          proteins: jsonMap['proteins'].toDouble(),
          fats: jsonMap['fats'].toDouble(),
          carbs: jsonMap['carbons'].toDouble(),
        );
      }).toList();
      return productList;
    } else {
      throw Exception('Błąd podczas pobierania produktów');
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
    throw Exception('Wystąpił błąd: $e');
  }
}

//dodaj nowy produkt POST
Future<void> add_new_product(String productName, int calories, double protiens, double fats, double carbons) async {
  const url = '$adres/createuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'product_name': productName,
    'calories': calories,
    'protiens': protiens,
    'fats': fats,
    'carbons': carbons,
  };
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final responseData = json.decode(response.body);
    }
  }
  catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
  }
}

//dodaj nowy produkt GET
Future<void> show_all_products() async {
  const url = '$adres/createuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {

  };
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {
      // ignore: unused_local_variable
      final responseData = json.decode(response.body);
    }
  }
  catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
  }
}


