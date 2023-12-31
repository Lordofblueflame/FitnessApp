// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import '../../animations/filling_glass_animation.dart';

class WaterButton extends StatefulWidget {
  late bool isFull;
  final VoidCallback onWaterLevelChanged;

   WaterButton({
    super.key,
    this.isFull = false,
    required this.onWaterLevelChanged,
  });

  @override
  WaterButtonState createState() => WaterButtonState();
}

class WaterButtonState extends State<WaterButton> {
  late bool isFull;
  final GlobalKey<FillingGlassAnimationState> _animationKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    isFull = widget.isFull;
    updateAnimationState();
  }

  @override
  void didUpdateWidget(WaterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFull != oldWidget.isFull) {
      isFull = widget.isFull;
      updateAnimationState();
    }
  }

  void updateAnimationState() async {
      if (isFull) {
        _animationKey.currentState?.setToFull();
      } else {
        _animationKey.currentState?.setToEmpty();
      }         
  }

  void toggleWaterAnimation() {
    _animationKey.currentState?.startAnimation();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onWaterLevelChanged,
      child: SizedBox(
        width: 37,
        height: 37,
        child: FillingGlassAnimation(
          key: _animationKey,
          animationStatusListener: (status) {
            if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
              widget.onWaterLevelChanged();
            }
          },
        ),
      ),
    );
  }
}
