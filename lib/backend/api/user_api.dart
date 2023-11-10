import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_models/user.dart';
import 'common_api.dart';
import '../log/debug_helper.dart';


Future<bool> updateWeightAndHeight(int userId, int weight, int height) async {
  DebugHelper.printFunctionName();

  final url = Uri.parse('$address/user/updateweightheight');
  
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'weight': weight,
      'height': height,
    }),
  );
  
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> changePassword(int userId, String currentPassword, String newPassword) async {
  DebugHelper.printFunctionName();

  final url = Uri.parse('$address/user/changepassword');
  
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'user_id': userId,
      'current_password': currentPassword,
      'new_password': newPassword,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

Future<bool> createUser(String username, String password, String email) async {
  DebugHelper.printFunctionName();

  const url = '$address/user/register';
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'username': username,
    'password': password,
    'email': email,
  };
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {
      return true;
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
        return false;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
      return false;
    }
  }
  return false;
}

Future<void> deleteUser(int id) async {
  DebugHelper.printFunctionName();

  const url = '$address/user/deleteuser';
  final headers = {'Content-Type': 'application/json'};
  final data = {'user_id': id};
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {
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

Future<String> recoverPassword(String email) async {
  DebugHelper.printFunctionName();

  const url = '$address/user/recoverpassword';
  final headers = {'Content-Type': 'application/json'};
  final data = {
    'email': email
  };
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      return responseData.toString();
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
        return "";
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
      return "";
    }
  }
  return "";
}

Future<bool> login(String username, String password) async {
  DebugHelper.printFunctionName();

  const url = '$address/user/login';
  final headers = {"Content-Type": "application/json"};
  final data = {
    "username": username,
    "password": password,
  };
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

    if (response.statusCode == 200) { 
      return true;
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
    return false;
  }
}

Future<User> getUserInfo(String username, String password) async {
  DebugHelper.printFunctionName();

  const url = '$address/user/getuserinfo';
  final headers = {'Content-Type': 'application/json'};

  final body = json.encode({
    'username': username,
    'password': password,
  });

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);   
      final user = User(
        userId: responseData['userid'],
        username: responseData['username'],
        email: responseData['email'],
        weight: responseData['weight'],
        height: responseData['height'],
      );

      return user;
    } else {
      throw Exception('Error fetching user information from Api ');
    }
  } catch (e) {
    if (kDebugMode) {
      print('An error occurred: $e');
    }
    throw Exception('An error occurred: $e');
  }
}
