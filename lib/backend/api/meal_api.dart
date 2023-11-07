import '../data_models/meal.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common_api.dart';
import '../log/debug_helper.dart';

Future<void> getMealName(int id) async {
  DebugHelper.printFunctionName();

  const url = '$address/createuser';
  final headers = {'Content-Type': 'application/json'};
  final data = {'meal_id': id};
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

Future<void> addNewMeal(String mealname) async {
  DebugHelper.printFunctionName();

  const url = '$address/createuser';
  final headers = {'Content-Type': 'application/json'};
  final data = {'meal_name': mealname};
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

Future<void> getMealById(int id) async {
  DebugHelper.printFunctionName();

  const url = '$address/createuser';
  final headers = {'Content-Type': 'application/json'};
  final data = {'meal_id': id};
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

Future<int> getMealIdByName(String mealName) async {
  DebugHelper.printFunctionName();

  final url = Uri.parse('$address/meal/getmealidbyname?mealName=$mealName');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final mealIdString = jsonResponse[0].toString();
    final valueString = mealIdString.substring(mealIdString.indexOf(':') + 1);
    final retval = int.parse(valueString);
    return retval;
  } else {
    throw Exception('Problem occurred during API request');
  }
}

Future<List<Meal>> getMeals() async {
  DebugHelper.printFunctionName();

  final response = await http.get(Uri.parse('$address/meal/getmeals'));
  
  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);

    final List<Meal> mealList = responseData.map((item) {
      final Map<String, dynamic> jsonMap = item;
      return Meal(
        mealName: jsonMap['meal_name'],
        mealId: jsonMap['meal_id'],
      );
    }).toList();

    return mealList;
  } else {
    throw Exception('Failed to fetch meals');
  }
}
