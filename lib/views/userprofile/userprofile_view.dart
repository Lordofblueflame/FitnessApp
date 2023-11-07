import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components/buttons/user_control_button.dart';
import '../../components/header_component.dart';
import '../../providers/user_provider.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      appBar: AppBar(
        flexibleSpace: const HeaderComponent(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/mainView');
          },
        ),
      ),
      body: Container(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Text("Welcome ${userProvider.user!.username}"),
            const SizedBox(height: 20),
            Text('Username:   ${userProvider.user!.username}'),
            const SizedBox(height: 10),
            Text('Email:    ${userProvider.user!.email}'),
            const SizedBox(height: 30),
            Text('Height:   ${userProvider.user!.height}'),
            const SizedBox(height: 10),
            Text('Weight:    ${userProvider.user!.weight}'),
            const SizedBox(height: 40),
            UserControlButton(
              onTap: () => Navigator.pushNamed(context, '/changepassword'),
              buttonText: 'Change Password',
            ),
            const SizedBox(height: 20),
            UserControlButton(
              onTap: () => Navigator.pushNamed(context, '/changeparameters'),
              buttonText: 'Update Parameters',
            ),
          ],
        ),
      ),
    );
  }
}
