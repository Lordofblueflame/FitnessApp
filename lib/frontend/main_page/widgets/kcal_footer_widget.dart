
import 'package:flutter/material.dart';

class KcalFooterWidget extends StatefulWidget {
  const KcalFooterWidget({
    super.key,
    required this.totalkcal,
    required this.neededkcal,
    required this.totalprot,
    required this.neededprot,
    required this.totalfats,
    required this.neededfats,
    required this.totalcarbs,
    required this.neededcarbs,
  });

  final int totalkcal;
  final int neededkcal;
  final double totalprot;
  final double neededprot;
  final double totalfats;
  final double neededfats;
  final double totalcarbs;
  final double neededcarbs;

  @override
  KcalFooterWidgetState createState() => KcalFooterWidgetState();
}

class KcalFooterWidgetState extends State<KcalFooterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.green[700]),
      child: Container(
        height: 50,
        decoration: const BoxDecoration(
        color: Color.fromARGB(210, 0, 1, 0),
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(20, 20),
          topRight: Radius.elliptical(20, 20)
          )
        ),
        child: Row(
          children: [
            Container( 
              margin: const EdgeInsets.only(left: 10),
              width: 85,                     
              child: Text(
                'Kcal ${widget.totalkcal} \n/${widget.neededkcal}',
                style: const TextStyle(color: Colors.white),
              ),           
            ),
            SizedBox(
              width: 85,
              child: Text(
                'Prot. ${widget.totalprot} \n/${widget.neededprot}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 85,
              child: Text(
                'Fats ${widget.totalfats} \n/${widget.neededfats}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(
              width: 85,
              child: Text(
                'Carbs ${widget.totalcarbs} \n/${widget.neededcarbs}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            InkWell(   
              child: const Text("User \nProfile",
                style: TextStyle(
                  color: Color.fromARGB(180, 150, 153, 153)
                ),
              ),
              onTap:() => {Navigator.pushNamed(context, '/userProfile')},
            )
          ]
        ),
      ),
    );
  }
}