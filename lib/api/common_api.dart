import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';

const String adres = "http://192.168.1.125:5000";

Future<void> connection() async {
  const url = "$adres/"; // Zmień adres na swój
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (kDebugMode) {
        print(responseData);
      } // Przetwarzaj odpowiedź odpowiednio
    } else {
      if (kDebugMode) {
        print('Błąd: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
  }
}