import 'package:flutter/material.dart';

import '../../constant/constant.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({Key? key, required this.controller, required this.hint}) : super(key: key);
  final TextEditingController controller ;
  final String hint;
  @override
  Widget build(BuildContext context) => TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Constant.FILLCOLOR,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Constant.BORDER_RADIUS),
          ),
        ),
      );
}
