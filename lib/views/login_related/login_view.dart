import '../../api/day_entries_api.dart';
import '../../api/meal_api.dart';
import '../../api/products_in_meal_api.dart';
import '../../components/buttons/user_control_button.dart';
import '../../components/small_components/image_square_title.dart';
import '../../components/small_components/textfield_with_controller.dart';
import '../../api/user_api.dart';
import '../../data_models/dayentries.dart';
import '../../data_models/meal.dart';
import '../../data_models/productsinmeal.dart';
import '../../data_models/user.dart';
import 'package:flutter/material.dart';


class LoginView extends StatelessWidget {
  LoginView({super.key, required this.isLoggedCallback});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final void Function(bool, User, List<Meal>, List<UserDayEntry>, List<ProductsInMeal>)? isLoggedCallback;

  @override
  Widget build(BuildContext context) {
    print(context);
    return Scaffold(
      backgroundColor: Colors.lightGreen[300],
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 25,
              ),
                    //icon
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(height: 50),

                    //  glad you come back
              Text(
                'Welcom back, you\'ve been missed!',
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 16,
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              // user textfield
              MyTextField(
                controller: usernameController,
                obscureText: false,
                hintText: "Username",
              ),

              const SizedBox(
                height: 25,
              ),

              //  password
              MyTextField(
                controller: passwordController,
                obscureText: true,
                hintText: "Password",
              ),

              //  forgot passwrod?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end, 
                  children: [
                    InkWell(
                      onTap: () => Navigator.pushReplacementNamed(context, '/forgotpassword'),
                      highlightColor: Colors.blue,
                      child: const Text('Forgot Password',
                      style: TextStyle(
                        color: Colors.green),
                      ),
                    )
                  ]
                )
              ),
              
              //  sign in button
              UserControlButton(
                onTap: () async {
                  bool retval = await login(usernameController.text,passwordController.text);
                  if(retval)
                  {         
                    try {
                      print(retval);
                      List<Meal> mealList = await fetchMeals();                   
                      User user = await getUserInfo(usernameController.text,passwordController.text);
                      List<UserDayEntry> initialList = await getUserDayEntries(user.userId);
                      List<ProductsInMeal> productsInMeal = await getProductInMealFromDayEntries(initialList); 
                      isLoggedCallback!(true,user,mealList,initialList,productsInMeal);
                      Map<String, dynamic> arguments = {
                        'User': User,
                        'mealList': mealList,
                        'initialList': initialList,
                        'productsInMeal': productsInMeal
                      };
                      Navigator.pushReplacementNamed(context, '/mainView', arguments: arguments);
                    } catch(e) {
                      print('Błąd podczas pobierania informacji o użytkowniku: $e');
                      showDialog(                     
                        context: context, 
                        builder: (BuildContext context) => const AlertDialog(
                          title: Text('Connection error'),
                          content: Text("Something went wrong with connection please try again in some time"),
                        )
                      );
                    }
                  }
                  else
                  {
                    showDialog(                     
                      context: context, 
                      builder: (BuildContext context) => const AlertDialog(
                        title: Text('Cannot login'),
                        content: Text("You've provided wrong username or password"),
                      )
                    );
                    return retval;
                  }
                },
                buttonText: 'Sign in'
              ),
              
              const SizedBox(
                height: 50,
              ),

                    // or continue with
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Or continue with",
                        style: TextStyle(
                        color: Colors.grey[700],
                      ),
                    )
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )
                  ),
                ],
              ),
              
              const SizedBox(
                height: 25,
              ),

                    //google
              const ImageSquareTitle(imagePath: "testapp/lib/assets/images/Glogo.png"),
                    //not a member register now!

              const SizedBox(
                height: 25,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member?',
                    style: TextStyle(
                      color: Colors.grey[700]
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  InkWell(
                      onTap: () => Navigator.pushReplacementNamed(context, '/register'),
                    hoverColor: Colors.blue,
                    highlightColor: Colors.blue,
                      child: const Text(
                        'Register Now',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
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
  /*
  Future<Map<String, dynamic>> prepareBeforeLogin() async
  {

    return arguments;
  }*/
}
