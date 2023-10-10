import 'dart:async';

import 'package:flutter/material.dart';

class BlinkContainer extends StatefulWidget {
  @override
  _BlinkContainerState createState() => _BlinkContainerState();
}

class _BlinkContainerState extends State<BlinkContainer> {
  bool _visible = true;
  late Timer _timer;

  @override
  void dispose() {
    // Clean up resources here
    _timer.cancel();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(milliseconds: 700), (timer) {
      if (mounted) {
        setState(() {
          _visible = !_visible;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 700),
      child: _visible
          ? Container(
              height: 16.0,
              width: 2.0,
              color: Colors.blue,
            )
          : const SizedBox(
              height: 20.0,
              width: 2.0,
            ),
    );
  }
}
