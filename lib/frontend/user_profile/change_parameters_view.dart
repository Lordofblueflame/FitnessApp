import '../../frontend/widgets/buttons/user_control_button.dart';
import '../main_page/widgets/header_widget.dart';
import '../../frontend/small_components/textfield_with_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import '../../business_logic/provider-architecture/user_provider.dart';

class ChangeParametersView extends StatelessWidget {
  ChangeParametersView({super.key});

  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context); // Access the UserProvider instance.

    heightController.text = userProvider.user?.height.toString() ?? '';
    weightController.text = userProvider.user?.weight.toString() ?? '';

    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      appBar: AppBar(
        flexibleSpace: const HeaderWidget(),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushNamed(context, '/userProfile');
          },
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text("Here you can update your weight and height"),
          const SizedBox(height: 20),
          const Text('Height: '),
          MyTextField(controller: heightController, hintText: '', obscureText: false),
          const SizedBox(height: 20),
          const Text('Weight: '),
          MyTextField(controller: weightController, hintText: '', obscureText: false),
          const SizedBox(height: 40),
          UserControlButton(
            onTap: () async {
              bool retval = await userProvider.updateWeightAndHeight(
                userProvider.user!.userId,
                int.parse(weightController.text),
                int.parse(heightController.text),
              );
              if (retval) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                    title: Text('Parameters Changed'),
                    content: Text("You've got new weight and height"),
                  ),
                );

                Navigator.pushNamed(context, '/userProfile');
              } else {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => const AlertDialog(
                    title: Text('Something went wrong'),
                    content: Text("You have encountered some issues here"),
                  ),
                );
              }
            },
            buttonText: 'Change Parameters',
          ),
        ],
      ),
    );
  }
}
