import 'dart:convert';
import '../data_models/day_entries.dart';
import 'package:http/http.dart' as http;
import 'common_api.dart';
import '../log/debug_helper.dart';

Future<bool> addNewEntry(int userId, String simpleDataFormat, int water, int workout, int productInMealId) async {
  DebugHelper.printFunctionName();
  final Uri url = Uri.parse('$address/dayentries/addnewentry');

  Map<String, dynamic> data = {
    'user_id': userId,
    'date': simpleDataFormat,
    'water': water,
    'workout': workout,
    'product_in_meal': productInMealId,
  };

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<List<UserDayEntry>> getUserDayEntries(int userId) async {
  DebugHelper.printFunctionName();

  final Uri url = Uri.parse('$address/dayentries/getuserdayentries?user_id=$userId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => UserDayEntry.fromJson(data)).toList();
  } else {
    throw Exception('Error fetching data from the API: ${response.statusCode}');
  }
}

Future<List<UserDayEntry>> getCurrentDayEntries(String date, int userId) async {
  DebugHelper.printFunctionName();

  final Uri url = Uri.parse('$address/dayentries/getdayentries?date=$date&user_id=$userId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<UserDayEntry> dayEntries = List<UserDayEntry>.from(jsonResponse.map((entry) => UserDayEntry.fromJson(entry)));
    return dayEntries;
  } else {
    throw Exception('Error fetching entries for a specific day: ${response.statusCode}');
  }
}
Future<bool> removeDayEntry(int entryId) async {
  DebugHelper.printFunctionName();
  final Uri url = Uri.parse('$address/dayentries/removedayentry?entry_id=$entryId');

  final response = await http.delete(url);

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Error removing day entry: ${response.statusCode}');
  }
}

Future<bool> updateDayEntry(int entryId, int newProductInMeal) async {
  DebugHelper.printFunctionName();
  final Uri url = Uri.parse('$address/dayentries/updatedayentry?entry_id=$entryId&product_in_meal=$newProductInMeal');

  final response = await http.put(
    url,
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    throw Exception('Error updating day entry: ${response.statusCode}');
  }
}

Future<int> findDayEntry(int userId, String date, int productInMealId) async {
  DebugHelper.printFunctionName();
  final Uri url = Uri.parse('$address/dayentries/finddayentry?user_id=$userId&date=$date&product_in_meal=$productInMealId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return jsonResponse['entry_id'];
  } else {
    throw Exception('Error finding day entry: ${response.statusCode}');
  }
}