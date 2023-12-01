import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/buttons/add_water_button.dart';
import '../../../business_logic/provider_architecture/water_intake_provider.dart';

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

void handleWaterButtonTap(int tappedIndex, bool send) {
  int lastFullIndex = buttonKeys.lastIndexWhere((element) => element.currentState!.isFull);
  int startIndex, endIndex;
  int affectedIndexes = 0;

  if (tappedIndex <= lastFullIndex) {
    startIndex = tappedIndex;
    endIndex = lastFullIndex;
    affectedIndexes = -(endIndex - startIndex + 1);
  } 
  else {
    startIndex = lastFullIndex ;
    endIndex = tappedIndex;
    affectedIndexes = endIndex - startIndex ; 
  }

  if(startIndex == -1) startIndex = 0;

  for (int i = startIndex + 1; i < endIndex; i++) {
    var currentState = buttonKeys[i].currentState;
    if (currentState != null) {
      currentState.isFull = (tappedIndex <= lastFullIndex) ? false : true;
      currentState.toggleWaterAnimation();
    }
  }

  if (send) {
    Provider.of<WaterIntakeProvider>(context, listen: false).updateWaterIntake(affectedIndexes);
  }

  setState(() { });
}


 void rebuildWaterButtonList(List<bool> newButtonStates) {
    waterButtonList = List.generate(newButtonStates.length, (index) {
      return WaterButton(
        key: buttonKeys[index], 
        isFull: newButtonStates[index],
        onWaterLevelChanged: () => handleWaterButtonTap(index, false),
      );
    });
    setState(() {
      
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
        onWaterLevelChanged: () => handleWaterButtonTap(index, true),
      );
    });
    
    return Container(
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
                    SingleChildScrollView(
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      child: Wrap(
                        spacing: 2,
                        children: waterButtonList 
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
  }
}