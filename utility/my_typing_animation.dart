import 'package:flutter/material.dart';

class MyTypingAnimation extends StatefulWidget {
  const MyTypingAnimation({super.key});
  final String extToType =
      "Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.Hello, World!.";

  @override
  _MyTypingAnimationState createState() => _MyTypingAnimationState();
}

class _MyTypingAnimationState extends State<MyTypingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _typedText = "";
  late String _textToType;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _textToType = widget.extToType;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 10),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller)
      ..addListener(() {
        if (_animation.value >= 0.99) {
          setState(() {
            if (_currentIndex < _textToType.length) {
              _typedText += _textToType[_currentIndex];
              _currentIndex++;
            } else {
              _controller.stop();
            }
          });
          _controller.reset();
          _controller.forward();
        }
      });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Text(
            _typedText,
            style: TextStyle(
              fontSize: 20,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
