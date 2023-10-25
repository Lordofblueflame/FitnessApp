import 'package:flutter/foundation.dart'; 
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../data_models/user.dart';
import 'common_api.dart';

Future<bool> updateWeightAndHeight(int userId, int weight, int height) async {
  final url = Uri.parse('$adres/api/update_weight_height');
  
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
    // Zmiana wagi i wzrostu pomyślna
    // Tutaj możesz wykonać odpowiednie akcje po zaktualizowaniu danych
    return true;
  } else {
    // Wystąpił błąd podczas zmiany wagi i wzrostu
    // Tutaj możesz obsłużyć błąd lub wyświetlić odpowiednie powiadomienie
    return false;
  }
}

Future<bool> changePassword(int userId, String currentPassword, String newPassword) async {
  final url = Uri.parse('$adres/api/change_password');
  
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
    // Zmiana hasła pomyślna
    // Tutaj możesz wykonać odpowiednie akcje po zmianie hasła
    return true;
  } else {
    // Wystąpił błąd podczas zmiany hasła
    // Tutaj możesz obsłużyć błąd lub wyświetlić odpowiednie powiadomienie
    return false;
  }
}

//data['username'],data['password'],data['email']
Future<bool> createUser(String username, String password, String email) async {
  const url = '$adres/user/register'; // Zmień adres na swój
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
      // ignore: unused_local_variable
      final responseData = json.decode(response.body);
        return true;
       // Przetwarzaj odpowiedź odpowiednio
    } else {
      if (kDebugMode) {
        print('Błąd: ${response.statusCode}');
        return false;
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
      return false;
    }
  }
  return false;
}

//(data['id'],
Future<void> deleteUser(int id) async {
  const url = '$adres/user/deleteuser'; // Zmień adres na swój
  final headers = {'Content-Type': 'application/json'};
  final data = {'user_id': id};
  final jsonData = json.encode(data);

  try {
    final response = await http.post(Uri.parse(url), headers: headers, body: jsonData);

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

//(data['email']
Future<String> recoverPassword(String email) async {
  const url = '$adres/user/recoverpassword'; // Zmień adres na swój
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
      // Przetwarzaj odpowiedź odpowiednio
    } else {
      if (kDebugMode) {
        print('Błąd: ${response.statusCode}');
        return "";
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
      return "";
    }
  }
  return "";
}

//data['username'],data['password']
Future<bool> login(String username, String password) async {
  const url = '$adres/user/login'; // Zmień adres na swój
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
        print('Błąd: ${response.statusCode}');
      }
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Wystąpił błąd: $e');
    }
    return false;
  }
}

Future<User> getUserInfo(String username, String password) async {
  final url = '$adres/user/getuserinfo';
  final headers = {'Content-Type': 'application/json'};

  final body = json.encode({
    'username': username,
    'password': password,
  });

  if (kDebugMode) {
    print(url);
  }

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body,
    );

    if (kDebugMode) {
      print(response);
    }

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);   
      final user = User(
        userId: responseData['userid'],
        username: responseData['username'],
        email: responseData['email'],
        weight: responseData['weight'],
        height: responseData['height'],
      );

      return user; // Return the User object
    } else {
      throw Exception('Błąd podczas pobierania informacji o użytkowniku z Api ');
    }
  } catch (e) {
    print('Wystąpił błąd: $e');
    throw Exception('Wystąpił błąd: $e');
  }
}

