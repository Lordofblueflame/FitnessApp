import 'package:flutter/material.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';

class ForgotPasswordViewModel extends ChangeNotifier{
  final emailController = TextEditingController();

  Future<String> recoverPassword(String email, UserProvider userProvider) async {
    String yourPassword = await userProvider.recoverUserPassword(email);
    return yourPassword;
  }
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }
}
