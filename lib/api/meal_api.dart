import '../data_models/meal.dart';
import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'common_api.dart';


//zwraca tylko nazwe po id GET
Future<void> get_meal_name(int id) async {
  const url = '$adres/createuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'meal_id': id,
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

//dodaj nowy posilek POST
Future<void> add_new_meal(String mealname) async {
  const url = '$adres/createuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'meal_name': mealname,
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

// zwraca cały posiłek po id GET
Future<void> get_meal_by_id(int id) async {
  const url = '$adres/createuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'meal_id': id,
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
Future<int> getMealIdByName(String mealName) async {
  final url = Uri.parse('$adres/meal/getmealidbyname?mealName=$mealName');

  final response = await http.get(url);
  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    String mealIdString  = jsonResponse[0].toString();
    String valueString = mealIdString .substring(mealIdString .indexOf(':') + 1);
    int retval = int.parse(valueString);
    return retval;
  } else {
    throw Exception('Wystąpił problem podczas żądania API');
  }
}

Future<List<Meal>> fetchMeals() async {
  final response = await http.get(Uri.parse('$adres/meal/getmeals'));
  print(response.statusCode);
  if (response.statusCode == 200) {
    final List<dynamic> responseData = json.decode(response.body);

    final List<Meal> MealList = responseData.map((item) {
        final Map<String, dynamic> jsonMap = item;
        return Meal(
          mealName: jsonMap['meal_name'],
          mealId: jsonMap['meal_id'],
        );
      }).toList();
    print(MealList[1].mealName);
    return MealList;

  } else {
    throw Exception('Failed to fetch meals');
  }
}