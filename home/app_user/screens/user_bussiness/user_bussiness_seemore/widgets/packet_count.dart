import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/basic.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class PacketCount extends StatefulWidget {
  const PacketCount({super.key});

  @override
  State<PacketCount> createState() => _PacketCountState();
}

class _PacketCountState extends State<PacketCount> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.red,
          height: 30,
          width: 30,
        ),
      ],
    );
  }
}
