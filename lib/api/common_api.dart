import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String address = "http://192.168.1.125:5000";

Future<void> connection() async {
  const url = "$address/"; 
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.get(Uri.parse(url), headers: headers);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      if (kDebugMode) {
        print(responseData);
      } 
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
  }
}
