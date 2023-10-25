import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddProductButton extends StatelessWidget {

  Function()? onTap;
  BoxShape shape;

  AddProductButton({Key? key, required this.onTap, BoxShape? shape})
      : shape = shape ?? BoxShape.rectangle,
        super(key: key);

  BorderRadiusGeometry? checkIfCircle()
  {
    if(shape == BoxShape.circle) 
    {
      return null;
    } 
    else 
    {
      return BorderRadius.circular(8);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(left: 40,top: 10, bottom: 15),
        decoration: BoxDecoration(
          shape: shape,
          color: Colors.green,                  
        ),
        child: Center(
          child: Image.asset(
            'testapp/lib/assets/images/Plus.png',
            height: 30,
            width: 30,
          ),
        ),
      ),
    );  
  }
}