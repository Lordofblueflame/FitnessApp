import 'package:flutter/material.dart';
import '../../widgets/buttons/user_control_button.dart';
import '../../small_components/textfield_with_controller.dart';
import '../../small_components/image_square_title.dart';
import '../../../backend/data_models/meal.dart';
import '../../../backend/data_models/day_entries.dart';
import '../../../backend/data_models/products_in_meal.dart';
import '../view_models/login_view_model.dart';

class LoginView extends StatelessWidget {
  final void Function(bool, List<Meal>, List<UserDayEntry>, List<ProductsInMeal>) isLoggedCallback;

  const LoginView({super.key, required this.isLoggedCallback});

  @override
  Widget build(BuildContext context) {
    final viewModel = LoginViewModel(context, isLoggedCallback);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.lightGreen[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Icon(Icons.lock, size: 100),
              const SizedBox(height: 50),
              Text('Welcom back, you\'ve been missed!',
                style: TextStyle(color: Colors.grey[700], fontSize: 16)),
              const SizedBox(height: 50),
              MyTextField(
                controller: viewModel.usernameController,
                obscureText: false,
                hintText: "Username",
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: viewModel.passwordController,
                obscureText: true,
                hintText: "Password",
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [
                    InkWell(
                      onTap: viewModel.navigateToForgotPassword,
                      highlightColor: Colors.blue,
                      child: const Text('Forgot Password',
                        style: TextStyle(color: Colors.green),
                      ),
                    )
                  ]
                )
              ),
              UserControlButton(
                onTap: viewModel.login,
                buttonText: 'Sign in'
              ),
              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400])),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text("Or continue with", style: TextStyle(color: Colors.grey[700])),
                  ),
                  Expanded(child: Divider(thickness: 0.5, color: Colors.grey[400])),
                ],
              ),
              const SizedBox(height: 25),
              const ImageSquareTitle(imagePath: "lib/assets/images/Glogo.png"),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: viewModel.navigateToRegister,
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                    child: const Text(
                      'Register Now',
                      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ) 
        )
      )
    );
  }
}
