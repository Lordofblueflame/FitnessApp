import 'package:flutter/foundation.dart';
import '../repositories/user_repository.dart';
import '../data_models/user.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository;

  UserProvider(this._userRepository);

  Future<bool> updateWeightAndHeight(int userId, int weight, int height) async {
    try {
      final success = await _userRepository.updateUserWeightAndHeight(userId, weight, height);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<bool> changeUserPassword(int userId, String currentPassword, String newPassword) async {
    try {
      final success = await _userRepository.changeUserPassword(userId, currentPassword, newPassword);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<bool> createNewUser(String username, String password, String email) async {
    try {
      final success = await _userRepository.createNewUser(username, password, email);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<void> deleteUserById(int id) async {
    try {
      await _userRepository.deleteUserById(id);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
    }
  }

  Future<String> recoverUserPassword(String email) async {
    try {
      final result = await _userRepository.recoverUserPassword(email);
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
      final success = await _userRepository.loginUser(username, password);
      if (success) {
        notifyListeners();
      }
      return success;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      return false;
    }
  }

  Future<User> getUserInfoByUsernameAndPassword(String username, String password) async {
    try {
      final responseData = await _userRepository.getUserInfoByUsernameAndPassword(username, password);
      return responseData;
    } catch (e) {
      if (kDebugMode) {
        print('An error occurred: $e');
      }
      throw Exception('An error occurred: $e');
    }
  }
}
