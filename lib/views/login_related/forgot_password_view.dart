import '../../api/user_api.dart';
import '../../components/buttons/user_control_button.dart';
import '../../components/small_components/textfield_with_controller.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:quiver/time.dart';

class ForgotPasswordView extends StatelessWidget{

  ForgotPasswordView({super.key});

  final emailController = TextEditingController();

  void forgotPasswordMethod() {}

  @override 
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/login'); // Powrót do poprzedniego widoku
          },
        ),
      ),
      backgroundColor: Colors.lightGreen[300],
      body: SafeArea(
        child: Center(
          child: Column(children: [

            const SizedBox(
              height: 150
            ),

            Text(
              'Forgot password? \n Enter you email and we will see what we can do',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,),
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 25
            ),

            MyTextField(
              controller: emailController,
              obscureText: false,
              hintText: "Enter your E-mail",
            ),

            const SizedBox(
              height: 25
            ),

            UserControlButton(
              onTap: () async {
                String yourPassword = await recoverPassword(emailController.text);

                if(yourPassword != "")
                {
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