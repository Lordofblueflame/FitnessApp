import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/user_control_button.dart';
import '../../small_components/textfield_with_controller.dart';
import '../view_models/register_view_model.dart';

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel is provided by a Provider widget in the widget tree
    final viewModel = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Return to previous view
          },
        ),
      ),
      backgroundColor: Colors.lightGreen[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 125),
              Text(
                'Hello there! \n General Kenobi... \n Here you can register',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: viewModel.usernameController,
                obscureText: false,
                hintText: "Username",
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: viewModel.passwordController,
                obscureText: true,
                hintText: "Password",
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: viewModel.emailController,
                obscureText: false,
                hintText: "Email",
              ),
              const SizedBox(height: 25),
              UserControlButton(
                onTap: () async {
                  bool retval = await viewModel.registerUser();
                  if (retval) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const AlertDialog(
                        title: Text("Good job"),
                        content: Text("You're now registered, Login in our app"),
                      ),
                    );
                    Navigator.pushNamed(context, '/login');
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => const AlertDialog(
                        title: Text("Something went bad"),
                        content: Text("There are some problems with registering now"),
                      ),
                    );
                  }
                },
                buttonText: 'Register Now',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
