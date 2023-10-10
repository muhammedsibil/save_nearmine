import 'package:flutter/material.dart';

class WelcomeCustomer extends StatefulWidget {
  WelcomeCustomer({
    super.key,
    required this.statusBusy,
    required this.statusAvailable,
    required this.statusOff,
  });
  final bool statusBusy;
  final bool statusAvailable;
  final bool statusOff;
  @override
  _WelcomeCustomerState createState() => _WelcomeCustomerState();
}

class _WelcomeCustomerState extends State<WelcomeCustomer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _animation;
  // late Animation _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    _animation = Tween(begin: -0.5, end: -0.05).animate(
        CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool switchAvailable = false;
  bool switchBusy = false;
  bool switchOff = false;
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    switchAvailable = widget.statusAvailable;
    switchBusy = widget.statusBusy;
    switchOff = widget.statusOff;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, Widget? child) {
        child = Transform(
          transform:
              Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (switchAvailable)
                  Icon(
                    IconData(0x1F64B, fontFamily: 'Emoji'),
                    size: 50.0,
                  ),
                SizedBox(
                  height: 10,
                ),
                if (switchAvailable)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      children: [
                        Text(
                          "Hi! Call me,",
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "Available",
                          style: TextStyle(
                              color: Colors.green, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )),
                if (switchBusy)
                  Padding(
                    padding: const EdgeInsets.only(left: 24.0),
                    child: Column(
                      children: [
                        Text(
                          "⌛️",
                          style: TextStyle(
                            fontSize: 50,
                          ),
                        ),
                        Text(
                          "I'm Busy",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
        return child;
      },
    );
  }
}
