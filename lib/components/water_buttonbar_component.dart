import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../api/day_entries_api.dart';
import '../data_models/user.dart';
import 'buttons/add_water_button.dart';

// ignore: must_be_immutable
class WaterButtonBarComponent extends StatefulWidget {
  late int water;
  final int neededWater;
  final DateTime date;
  final User user;
  final double waterButtonSize = 150.0; // Rozmiar jednego WaterButton

  WaterButtonBarComponent({
    Key? key,
    required this.water,
    required this.neededWater,
    required this.date,
    required this.user,
  }) : super(key: key);

  @override
  _WaterButtonBarComponentState createState() => _WaterButtonBarComponentState();
}

class _WaterButtonBarComponentState extends State<WaterButtonBarComponent> {
  int waterButtonCount = 0;

  @override
  void initState() {
    super.initState();
    updateWaterButtonCount();
  }

  void updateWaterButtonCount() {
    waterButtonCount = (widget.neededWater / widget.waterButtonSize).ceil();
    setState(() {});
  }

  void handleWaterButtonTap(bool isTapped) async {
    if (isTapped) {
      setState(() {
        widget.water += 150;
      });
      Map<String, dynamic> data = {
        'user_id': widget.user.userId,
        'date': DateFormat('yyyy-MM-dd').format(widget.date),
        'water': 150,
        'workout': 0,
        'product_in_meal': 0,
      };
      await addNewEntry(data);
    } else {
      setState(() {
        widget.water -= 150;
      });
        Map<String, dynamic> data = {
        'user_id': widget.user.userId,
        'date': DateFormat('yyyy-MM-dd').format(widget.date),
        'water': -150,
        'workout': 0,
        'product_in_meal': 0,
      };
      await addNewEntry(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 400,
      height: 150,
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.lightGreen[500],
            border: Border.all(color: Colors.black),
            borderRadius: const BorderRadius.horizontal(
              left: Radius.elliptical(25, 10),
              right: Radius.elliptical(25, 10),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    const Text(
                      'Water',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      '${widget.water} ml / ${widget.neededWater} ml',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 2,
                      children: List.generate(waterButtonCount, (_) => WaterButton(
                        date: widget.date,
                        user: widget.user,
                        onTap: handleWaterButtonTap,
                      )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
