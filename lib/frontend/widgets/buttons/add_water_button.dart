import 'package:flutter/material.dart';
import '../../../backend/data_models/user.dart';
import '../../animations/filling_glass_animation.dart';

class WaterButton extends StatefulWidget {
  final DateTime date;
  final User user;
  final bool isFull; 
  final Function(bool isTapped) onTap;

  const WaterButton({
    super.key,
    required this.date,
    required this.user,
    this.isFull = false,
    required this.onTap,
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
  }

  @override
  void didUpdateWidget(WaterButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFull != isFull) {
      isFull = widget.isFull;
      if (isFull) {
        _animationKey.currentState?.setToFull();
      } else {
        _animationKey.currentState?.setToEmpty();
      }
    }
  }

  void toggleWaterLevel() {
    _animationKey.currentState?.startAnimation();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleWaterLevel,
      child: SizedBox(
        width: 37,
        height: 37,
        child: FillingGlassAnimation(
          key: _animationKey,
          animationStatusListener: (status) {
            if (status == AnimationStatus.completed) {
              setState(() => isFull = true);
              widget.onTap(true);
            } else if (status == AnimationStatus.dismissed) {
              setState(() => isFull = false);
              widget.onTap(false);
            }
          },
        ),
      ),
    );
  }
}
