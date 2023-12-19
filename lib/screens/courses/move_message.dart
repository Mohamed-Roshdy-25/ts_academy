import 'dart:math';

import 'package:flutter/material.dart';

import '../../constants/constants.dart';

class MovingText extends StatefulWidget {
  @override
  _MovingTextState createState() => _MovingTextState();
}

class _MovingTextState extends State<MovingText> {
  double _xPosition = 0;
  double _yPosition = 0;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _moveText();
    }
  }

  void _moveText() {
    if (mounted) {
      setState(() {
        _xPosition = _randomPosition();
        _yPosition = _randomPosition();
      });
      Future.delayed(const Duration(milliseconds: 500), () {
        _moveText();
      });
    }
  }

  double _randomPosition() {
    return (100 * (Random().nextInt(5) * (0.5 - (10020 % 1000) / 1000)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          left: _xPosition,
          top: _yPosition,
          child: AnimatedContainer(
            duration: const Duration(seconds: 1),
            curve: Curves.easeInOut,
            child: Transform.rotate(
              angle: 75,
              child: Text(
                '$myName-$stuId',
                style: const TextStyle(fontSize: 24, color: Colors.blueAccent),
              ),
            ),
          ),
        )
      ],
    ));
  }
}

////////////////////////////////////////////////////////////////////

class MovingTextWidget extends StatefulWidget {
  const MovingTextWidget({Key? key}) : super(key: key);

  @override
  _MovingTextWidgetState createState() => _MovingTextWidgetState();
}

class _MovingTextWidgetState extends State<MovingTextWidget>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  double _position = 0.0;
  double _position2 = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _animationController.addListener(() {
      setState(() {
        _position =
            _animationController.value * MediaQuery.of(context).size.width;
        _position2 =
            _animationController.value * MediaQuery.of(context).size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration.zero,
      left: _position,
      top: _position2,
      child: const Text(
        'Hello, world!',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class MovingTextWidget2 extends StatefulWidget {
  const MovingTextWidget2({Key? key}) : super(key: key);

  @override
  _MovingTextWidget2State createState() => _MovingTextWidget2State();
}

class _MovingTextWidget2State extends State<MovingTextWidget2>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  double _position = 0.0;
  double _position2 = 0.0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _animationController.addListener(() {
      setState(() {
        _position =
            _animationController.value * MediaQuery.of(context).size.width;
        _position2 =
            _animationController.value * MediaQuery.of(context).size.height;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration.zero,
      right: _position,
      bottom: _position2,
      child: const Text(
        'Hello, world!',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
