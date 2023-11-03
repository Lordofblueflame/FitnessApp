import 'package:flutter/material.dart';

import '../../components/buttons/user_control_button.dart';
import '../../components/header_component.dart';
import '../../components/small_components/textfield_with_controller.dart';
import '../../providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChangePasswordView extends StatelessWidget {
  ChangePasswordView({super.key});

  final oldPassController = TextEditingController();
  final newPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      appBar: AppBar(
        flexibleSpace : const HeaderComponent(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/userprofile'); // Powrót do poprzedniego widoku
          },       
        )
      ),
      body: Container(
        child: Column(
          children: [

            const SizedBox(height: 40,),

            const Text("To change password provide old password"),

            const SizedBox(height: 20,),

            const Text('Old password: '),
            MyTextField(controller: oldPassController, hintText: '', obscureText: true),
       
            const SizedBox(height: 20,),

            const Text('New password: '),
            MyTextField(controller: newPassController, hintText: '', obscureText: true),
              
            const SizedBox(height: 40,),

            UserControlButton(
              onTap: () async {     
                bool retval = await userProvider.changeUserPassword(userProvider.user!.userId,oldPassController.text,newPassController.text);
                if(retval){
                  showDialog(                     
                    context: context, 
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text('Password Changed'),
                      content: Text("You've got new password"),
                    )
                  );

                Navigator.pushNamed(context, '/userprofile');
                }
                else{
                  showDialog(                     
                    context: context, 
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text('Something went wrong'),
                      content: Text("You have encountered some issues here"),
                    )
                  );                 
                }
              }, 
              buttonText: 'Change Password'
            ),
          ]
        ),
      ),
    );
  }
}

