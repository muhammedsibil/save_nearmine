import 'package:flutter/material.dart';

class Image3D extends StatefulWidget {
  final Widget child;

  const Image3D({super.key, required this.child});
  @override
  _Image3DState createState() => _Image3DState();
}

class _Image3DState extends State<Image3D> {
  double _rotationX = 0.0;
  double _rotationY = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _rotationY += details.delta.dx / 80;
          _rotationX -= details.delta.dy / 80;
        });
      },
      child: Transform(
        alignment: Alignment.center,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateY(_rotationY)
          ..rotateX(_rotationX),
        child: widget.child,
      ),
    );
  }
}
