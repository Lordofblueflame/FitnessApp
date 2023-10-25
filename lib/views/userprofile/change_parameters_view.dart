import '../../api/user_api.dart';
import '../../components/buttons/user_control_button.dart';
import '../../components/header_component.dart';
import '../../components/small_components/textfield_with_controller.dart';
import 'package:flutter/material.dart';
import '../../data_models/user.dart';

class ChangeParametersView extends StatelessWidget {
  ChangeParametersView({super.key, required this.user});

  final User user;
  
  final heightcontroller = TextEditingController();
  final weighController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    heightcontroller.text = user.height.toString();
    weighController.text = user.weight.toString();

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
            
            const Text("Here you can update your weight and height"),

            const SizedBox(height: 20,),

            const Text('Height: '),
            MyTextField(controller: heightcontroller, hintText: '', obscureText: false),

            const SizedBox(height: 20,),

            const Text('Weight: '),
            MyTextField(controller: weighController, hintText: '', obscureText: false),
                 
            const SizedBox(height: 40,),

            UserControlButton(
              onTap: () async {
                bool retval = await updateWeightAndHeight(user.userId,int.parse(weighController.text),int.parse(heightcontroller.text));
                if(retval){
                  showDialog(                     
                    context: context, 
                    builder: (BuildContext context) => const AlertDialog(
                      title: Text('Parameters Changed'),
                      content: Text("You've got new weight and height"),
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
              buttonText: 'Change Parameters'
            ),
          ]
        ),
      ),
    );
  }
}

