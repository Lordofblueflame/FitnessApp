import '../../data_models/user.dart';
import 'package:flutter/widgets.dart';
import 'dart:async';

class WaterButton extends StatefulWidget {
  final DateTime date;
  final User user;
  final Function(bool isTapped) onTap;

  const WaterButton({
    Key? key,
    required this.date,
    required this.user,
    required this.onTap,
  }) : super(key: key);

  @override
  WaterButtonState createState() => WaterButtonState();
}

class WaterButtonState extends State<WaterButton> {
  bool isTapped = false;
  bool isEmpty = true;
  String source = "lib/assets/images/empty.png";

  void changeSourceWithDelay() {
    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        if (isEmpty) {
          source = "lib/assets/images/half.png";
        } else {
          source = "lib/assets/images/overhalf.png";
        }
      });
    });
    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        if (isEmpty) {
          source = "lib/assets/images/overhalf.png";
        } else {
          source = "lib/assets/images/half.png";
        }
      });
    });
    Timer(const Duration(milliseconds: 250), () {
      setState(() {
        if (isEmpty) {
          source = "lib/assets/images/full.png";
          isEmpty = false;
        } else {
          source = "lib/assets/images/empty.png";
          isEmpty = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isTapped = !isTapped;
          widget.onTap(isTapped); // Wywołanie funkcji przekazanej z WaterButtonBarComponent
          changeSourceWithDelay();
        });
      },
      child: Image.asset(
        source,
        height: 37,
        width: 37,
      ),
    );
  }
}
