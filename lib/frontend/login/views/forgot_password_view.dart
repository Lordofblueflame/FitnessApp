import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/user_control_button.dart';
import '../../small_components/textfield_with_controller.dart';
import '../view_models/forgot_password_view_model.dart';
import '../../../business_logic/provider-architecture/user_provider.dart';

class ForgotPasswordView extends StatelessWidget {
  const ForgotPasswordView({super.key});

  @override 
  Widget build(BuildContext context) {
    final viewModel = Provider.of<ForgotPasswordViewModel>(context);
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Use pop instead of navigating with a route name for going back.
          },
        ),
      ),
      backgroundColor: Colors.lightGreen[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [
            const SizedBox(height: 150),
            Text(
              'Forgot password? \n Enter you email and we will see what we can do',
              style: TextStyle(color: Colors.grey[700], fontSize: 16,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            MyTextField(
              controller: viewModel.emailController,
              obscureText: false,
              hintText: "Enter your E-mail",
            ),
            const SizedBox(height: 25),
            UserControlButton(
              onTap: () async {
                String yourPassword = await viewModel.recoverPassword(viewModel.emailController.text,userProvider);
                if(yourPassword != "") {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Recovered Password'),
                      content: Text("Your password is: $yourPassword"),
                    )
                  );            
                }
              }, 
              buttonText: "Recover password"
            ),
          ],)
        ),
      )
    );
  }
}
