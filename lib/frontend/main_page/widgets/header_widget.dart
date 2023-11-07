import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget{
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[700]
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 190, 255, 154),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.elliptical(30, 20),
            bottomRight: Radius.elliptical(30, 20)
          ),
        ),
        child: const Column(
          children: [
            SizedBox(height: 25,),
            Text(
              'Fitatuj',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,                     
              ),
            ),
          ],
        ),
      ),
    );
  }
}