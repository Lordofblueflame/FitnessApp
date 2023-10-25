import '../../api/user_api.dart';
import '../../components/buttons/user_control_button.dart';
import '../../components/small_components/textfield_with_controller.dart';
import 'package:flutter/material.dart';

class RegisterNowView extends StatelessWidget{
  RegisterNowView({super.key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();

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
              height: 125
            ),

            Text('Hello there! \n General Kenobi... \n Here you can register',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(
              height: 25
            ),

            MyTextField(
              controller: usernameController,
              obscureText: false,
              hintText: "Username",
            ),

            const SizedBox(
              height: 10,
            ),

            //  password
            MyTextField(
              controller: passwordController,
              obscureText: true,
              hintText: "Password",
            ),

            const SizedBox(
              height: 10,
            ),

            //  password
            MyTextField(
              controller: emailController,
              obscureText: false,
              hintText: "Email",
            ),

            const SizedBox(
              height: 25,
            ),

            UserControlButton(
              onTap:() async {
                bool retval = await createUser(usernameController.text,passwordController.text,emailController.text);

                if(retval)
                {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text("Good job"),
                      content: Text("You're now registered, Login in our app"),
                    )
                  );
                  Navigator.pushNamed(context, '/login');
                }
                else
                {
                  showDialog(
                    context: context, 
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text("Something went bad"),
                      content: Text("There are some problems with registering now"),
                    )
                  );
                }
              }, 
              buttonText: 'Register Now',
              ),
            ],
          ),
        ) 
      ),
    );
  }
}