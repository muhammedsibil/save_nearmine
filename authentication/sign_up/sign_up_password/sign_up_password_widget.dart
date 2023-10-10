import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_in/sign_in_screen.dart';

import '../../../constant/constant.dart';
import '../../../home/home_screen.dart';
import '../../constant/heading_widget.dart';
import '../../constant/text_field_widget.dart';

class SignUpPasswordWidget extends StatefulWidget {
  const SignUpPasswordWidget({Key? key}) : super(key: key);

  @override
  State<SignUpPasswordWidget> createState() => _SignUpPasswordWidgetState();
}

class _SignUpPasswordWidgetState extends State<SignUpPasswordWidget> {
  TextEditingController passwordController = TextEditingController();

  _onPressMethod() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()),
      );

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeadingWidget(heading: "Password"),
          const SizedBox(
            height: 8,
          ),
          TextFieldWidget(
            hint: "Password",
            controller: passwordController,
          ),
          Spacer(),
          ButtonWidget(text: "Next", onPressed: _onPressMethod),
        ],
      ),
    );
  }
}
