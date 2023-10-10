import 'dart:async';

import 'package:flutter/material.dart';

class CongratsAlertOrder extends StatefulWidget {
  const CongratsAlertOrder({
    super.key,
    required this.shopName,
    required this.shopNumber,
  });
  final String shopNumber;
  final String shopName;
  @override
  State<CongratsAlertOrder> createState() => _CongratsAlertOrderState();
}

class _CongratsAlertOrderState extends State<CongratsAlertOrder> {
  bool showCongratulationsText = true;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 3)),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox();
        } else {
          return Container(
            key: const ValueKey<bool>(true),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  const Text("Congratulations! Your order has been placed"),
                  Text(widget.shopName.toString()),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
