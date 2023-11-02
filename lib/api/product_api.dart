import '../data_models/productsinmeal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_models/product.dart';
import 'common_api.dart';
import '../log/debug_helper.dart';

Future<Product> getProductById(int id) async {
  DebugHelper.printFunctionName();

  final url = '$address/product/getproduct?product_id=$id';
  final headers = {'Content-Type': 'application/json'};

  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      final Product product = Product(
        product_id: responseData['product_id'],
        productName: responseData['product_name'],
        calories: responseData['calories'],
        proteins: responseData['proteins'].toDouble(),
        fats: responseData['fats'].toDouble(),
        carbs: responseData['carbons'].toDouble(),
      );

      return product;
    } else {
      throw Exception('Error fetching product: ${response.statusCode}');
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
    throw Exception('An error occurred while communicating with the server');
  }
}

Future<List<Product>> getListOfProductsFromProductsInMeal(List<ProductsInMeal> productsinmeal) async {
  DebugHelper.printFunctionName();

  final List<Product> productList = [];

  for (final entry in productsinmeal) {
    final Product product = await getProductById(entry.productId);

    productList.add(product);
  }

  return productList;
}

Future<List<Product>> searchForProducts(String productName) async {
  DebugHelper.printFunctionName();

  final url = '$address/product/getproductbyname?product_name=$productName';
  final headers = {'Content-Type': 'application/json'};

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
      throw Exception('Error fetching products');
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
    throw Exception('An error occurred: $e');
  }
}

Future<void> addNewProduct(String productName, int calories, double protiens, double fats, double carbons) async {
  DebugHelper.printFunctionName();

  const url = '$address/createuser'; // Change the address to your desired endpoint
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

    if (response.statusCode == 200) {}
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
  }
}

Future<dynamic> showAllProducts() async {
  DebugHelper.printFunctionName();

  const url = '$address/createuser';
  final headers = {'Content-Type': 'application/json'};
  final data = {};

  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {}
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
  }
}
