import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/add_water_button.dart';
import '../../../business_logic/provider-architecture/water_intake_provider.dart';

class WaterButtonBarComponent extends StatefulWidget {
  const WaterButtonBarComponent({super.key});

  @override
  _WaterButtonBarComponentState createState() => _WaterButtonBarComponentState();
}

class _WaterButtonBarComponentState extends State<WaterButtonBarComponent> {
  late List<WaterButton> waterButtonList;
  late List<GlobalKey<WaterButtonState>> buttonKeys;

  @override
  void initState() {
    super.initState();
    buttonKeys = List.generate(Provider.of<WaterIntakeProvider>(context, listen: false).buttonCount, (index) => GlobalKey<WaterButtonState>());
  }

void handleWaterButtonTap(int tappedIndex) {
  Provider.of<WaterIntakeProvider>(context, listen: false).updateWaterIntake(tappedIndex);
  int startIndex = waterButtonList.indexWhere((element) => element.isFull);

  if (startIndex == -1) {
    startIndex = 0;
  }

  if (startIndex > tappedIndex) {
    for (int i = tappedIndex; i < startIndex; i++) {
      var currentState = buttonKeys[i].currentState;
      if (currentState != null && currentState.isFull) {
        currentState.isFull = false; 
        currentState.toggleWaterLevel(); 
      }
    }
  } else {

    for (int i = startIndex; i <= tappedIndex; i++) {
      var currentState = buttonKeys[i].currentState;
      if (currentState != null && !currentState.isFull) {
        currentState.isFull = true; 
        currentState.toggleWaterLevel(); 
      }
    }
  }
  setState(() {  
  });
}

 void rebuildWaterButtonList(List<bool> newButtonStates) {
    waterButtonList = List.generate(newButtonStates.length, (index) {
      return WaterButton(
        key: buttonKeys[index], 
        isFull: newButtonStates[index],
        onWaterLevelChanged: () => handleWaterButtonTap(index),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var waterModel = Provider.of<WaterIntakeProvider>(context);
    int currentWater = waterModel.currentWater;
    int neededWater = waterModel.neededWater;
    waterButtonList = List.generate(waterModel.buttonCount, (index) {
      bool isFull = (index + 1) * waterModel.waterIncrement <= currentWater;
      return WaterButton(
        key: buttonKeys[index],
        isFull: isFull,
        onWaterLevelChanged: () => handleWaterButtonTap(index),
      );
    });
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
                      '$currentWater ml / $neededWater ml',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 2,
                      children: waterButtonList 
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
