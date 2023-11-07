import 'package:flutter/foundation.dart';
import '../data_models/user.dart';
import '../api/user_api.dart';

class UserRepository {
  Future<bool> updateUserWeightAndHeight(int userId, int weight, int height) async {
    try {
      await updateWeightAndHeight(userId, weight, height);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<bool> changeUserPassword(int userId, String currentPassword, String newPassword) async {
    try {
      await changePassword(userId, currentPassword, newPassword);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<bool> createNewUser(String username, String password, String email) async {
    try {
      await createUser(username, password, email);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<void> deleteUserById(int id) async {
    try {
      await deleteUser(id);
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
    }
  }

  Future<String> recoverUserPassword(String email) async {
    try {
      final result = await recoverPassword(email);
      return result;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return "";
    }
  }

  Future<bool> loginUser(String username, String password) async {
    try {
      await login(username, password);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<User> getUserInfoByUsernameAndPassword(String username, String password) async {
    try {
      final responseData = await getUserInfo(username, password);
      return responseData;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      throw Exception('An error occurred: $e');
    }
  }
}
