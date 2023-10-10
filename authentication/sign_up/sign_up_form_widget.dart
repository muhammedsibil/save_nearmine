import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_in/sign_in_screen.dart';

import '../../constant/constant.dart';
import '../constant/heading_widget.dart';
import '../constant/text_field_widget.dart';

class SignUpFormWidget extends StatefulWidget {
  const SignUpFormWidget({Key? key}) : super(key: key);

  @override
  State<SignUpFormWidget> createState() => _SignUpFormWidgetState();
}

class _SignUpFormWidgetState extends State<SignUpFormWidget> {
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  _onPressMethod ()   => 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignInScreen()),
            );
          
  @override
  void dispose() {
    phoneNumberController.dispose();
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
          const HeadingWidget(heading: "Phone Number"),
          const SizedBox(
            height: 8,
          ),
          TextFieldWidget(
            hint: "Phone number",
            controller: phoneNumberController,
          ),
          const SizedBox(
            height: 14,
          ),
          const HeadingWidget(heading: "Password"),
          const SizedBox(
            height: 8,
          ),
          TextFieldWidget(controller: passwordController, hint: "Password"),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(text: "Next",onPressed: _onPressMethod),
        ],
      ),
    );
  }


}
