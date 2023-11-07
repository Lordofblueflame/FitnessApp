import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../backend/api/day_entries_api.dart';
import '../../../backend/data_models/user.dart';
import '../../widgets/buttons/add_water_button.dart';

class WaterButtonBarComponent extends StatefulWidget {
  final int initialWater;
  final int neededWater;
  final DateTime date;
  final User user;

  const WaterButtonBarComponent({
    super.key,
    required this.initialWater,
    required this.neededWater,
    required this.date,
    required this.user,
  });

  @override
  _WaterButtonBarComponentState createState() => _WaterButtonBarComponentState();
}

class _WaterButtonBarComponentState extends State<WaterButtonBarComponent> {
  late int currentWater;
  late int waterButtonCount;
  final int waterIncrement = 150;

  @override
  void initState() {
    super.initState();
    initializeValues();
  }

  @override
  void didUpdateWidget(WaterButtonBarComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialWater != oldWidget.initialWater) {
      initializeValues();
    }
  }

  void initializeValues() {
    currentWater = widget.initialWater;
    waterButtonCount = (widget.neededWater / waterIncrement).ceil();
  }

  void handleWaterButtonTap(bool isTapped) async {
    int waterChange = isTapped ? waterIncrement : -waterIncrement;
    int newWaterLevel = (currentWater + waterChange).clamp(0, widget.neededWater);

    setState(() {
      currentWater = newWaterLevel;
    });

    try {
      Map<String, dynamic> data = {
        'user_id': widget.user.userId,
        'date': DateFormat('yyyy-MM-dd').format(widget.date),
        'water': waterChange,
        'workout': 0,
        'product_in_meal': 0,
      };
      bool success = await addNewEntry(data);
      if (!success) {
        throw Exception('Failed to update water data');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating water data: $e')),
      );
      setState(() {
        currentWater -= waterChange;
      });
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
                      '$currentWater ml / ${widget.neededWater} ml',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 2,
                      children: List.generate(waterButtonCount, (index) {
                        bool isButtonActive = (index + 1) * waterIncrement <= currentWater;
                        return WaterButton(
                          date: widget.date,
                          user: widget.user,
                          isFull: isButtonActive,
                          onTap: handleWaterButtonTap,
                        );
                      }),
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

