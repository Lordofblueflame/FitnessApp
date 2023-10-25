import 'dart:convert';
import '../data_models/dayentries.dart';
import 'package:http/http.dart' as http;
import 'common_api.dart';

Future<void> addNewEntry(Map<String, dynamic> data) async {
  final Uri url = Uri.parse('$adres/dayentries/addnewentry');

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(data),
  );

  if (response.statusCode == 200) {
    // Udało się dodać nowy wpis
  } else {
    // Wystąpił błąd podczas żądania API
  }
}

Future<List<UserDayEntry>> getUserDayEntries(int userId) async {
  final Uri url = Uri.parse('$adres/dayentries/getuserdayentries?user_id=$userId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> jsonResponse = jsonDecode(response.body);
    return jsonResponse.map((data) => UserDayEntry.fromJson(data)).toList();
  } else {
    throw Exception('Błąd podczas pobierania danych z API: ${response.statusCode}');
  }
}

Future<List<UserDayEntry>> getCurrentDayEntries(String date, int userId) async {
  final Uri url = Uri.parse('$adres/dayentries/getdayentries?date="$date"&user_id=$userId');

  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    final List<UserDayEntry> dayEntries = List<UserDayEntry>.from(jsonResponse.map((entry) => UserDayEntry.fromJson(entry)));
    return dayEntries;
  } else {
    throw Exception('Błąd podczas pobierania wpisów na dany dzień: ${response.statusCode}');
  }
}