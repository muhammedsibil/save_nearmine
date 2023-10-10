import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../constant/constant.dart';

class HeadingWidget extends StatelessWidget {
  const HeadingWidget({Key? key, required this.heading}) : super(key: key);
  final String heading;
  @override
  Widget build(BuildContext context) {
    return Text(
      heading,
      style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: Constant.PRIMARY_BLACK),
    );
  }
}
