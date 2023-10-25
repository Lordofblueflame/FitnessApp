import '../../components/buttons/user_control_button.dart';
import '../../components/header_component.dart';
import 'package:flutter/material.dart';
import '../../data_models/user.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({super.key, required this.thisUser});

  final User thisUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      appBar: AppBar(
        flexibleSpace : const HeaderComponent(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/mainView'); // Powrót do poprzedniego widoku
          },       
        )
      ),
      body: Container(
        child: Column(
          children: [

            const SizedBox(height: 40,),
            
            Text("Welcome ${thisUser.username}"),

            const SizedBox(height: 20,),

            Text('Username:   ${thisUser.username}'),

            const SizedBox(height: 10,),
            
            Text('Email:    ${thisUser.email}'),
            
            const SizedBox(height: 30,),

            Text('Height:   ${thisUser.height}'),

            const SizedBox(height: 10,),
            
            Text('Weight:    ${thisUser.weight}'),
            
            const SizedBox(height: 40,),

            UserControlButton(
              onTap: () => {Navigator.pushNamed(context, '/changepassword')},  
              buttonText: 'Change Password'
            ),

            const SizedBox(height: 20,),

            UserControlButton(
              onTap: () => {Navigator.pushNamed(context, '/changeparameters')}, 
              buttonText: 'Update Parameters'
            )
          ]
        ),
      ),
    );
  }
}

