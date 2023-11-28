import 'dart:async';

import 'package:flutter/material.dart';

typedef AnimationStatusCallback = void Function(AnimationStatus status);

class FillingGlassAnimation extends StatefulWidget {
  final AnimationStatusCallback? animationStatusListener;

  const FillingGlassAnimation({super.key, this.animationStatusListener});

  @override
  FillingGlassAnimationState createState() => FillingGlassAnimationState();
}

class FillingGlassAnimationState extends State<FillingGlassAnimation> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation<double>? _animation;

  final List<Image> _glassImages = [
    Image.asset("lib/assets/images/empty.png", fit: BoxFit.contain),
    Image.asset("lib/assets/images/half.png", fit: BoxFit.contain),
    Image.asset("lib/assets/images/overhalf.png", fit: BoxFit.contain),
    Image.asset("lib/assets/images/full.png", fit: BoxFit.contain),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0, end: _glassImages.length.toDouble())
      .animate(_animationController!)
      ..addListener(() {
        setState(() {});
      });
  }

  Future<void> startAnimation() {
    Completer<void> completer = Completer<void>();
    if (_animationController!.isCompleted) {
      _animationController!.reverse();
    } else {
      _animationController!.forward();
    }

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.completed || status == AnimationStatus.dismissed) {
        if (!completer.isCompleted) {
          completer.complete();
        }
      }
    });

    return completer.future;
  }

  void setToFull() {
    if (_animationController != null) {
      _animationController!.value = _glassImages.length.toDouble();
    }
  }

  void setToEmpty() {
    if (_animationController != null) {
      _animationController!.value = 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_animationController == null || _animation == null) {
      return Container();
    }

    int frame = _animationController!.isCompleted
      ? _glassImages.length - 1
      : _animation!.value.floor() % _glassImages.length;

    return Stack(
      children: [
        Positioned.fill(
          child: _glassImages[frame],
        ),
      ],
    );
  }
}
