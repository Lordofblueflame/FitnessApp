import 'package:flutter/material.dart';
import '../../../backend/api/user_api.dart';

class RegisterViewModel with ChangeNotifier {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

  Future<bool> registerUser() async {
    bool retval = await createUser(
      usernameController.text,
      passwordController.text,
      emailController.text,
    );
    return retval;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }
}
