import 'dart:convert';
import '../data_models/dayentries.dart';
import 'package:http/http.dart' as http;
import 'common_api.dart';
import '../log/debug_helper.dart';

Future<void> addNewEntry(Map<String, dynamic> data) async {
  DebugHelper.printFunctionName();
  final Uri url = Uri.parse('$address/dayentries/addnewentry');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
  } else {
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
