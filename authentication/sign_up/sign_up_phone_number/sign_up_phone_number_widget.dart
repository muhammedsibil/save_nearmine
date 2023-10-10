import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_in/sign_in_screen.dart';

import '../../../constant/constant.dart';
import '../../constant/heading_widget.dart';
import '../../constant/text_field_widget.dart';
import '../sign_up_password/sign_up_password_screen.dart';

class SignUpPhoneNumberWidget extends StatefulWidget {
  const SignUpPhoneNumberWidget({Key? key}) : super(key: key);

  @override
  State<SignUpPhoneNumberWidget> createState() => _SignUpPhoneNumberWidgetState();
}

class _SignUpPhoneNumberWidgetState extends State<SignUpPhoneNumberWidget> {
  TextEditingController phoneNumberController = TextEditingController();

  _onPressMethod() => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SignUpPasswordScreen()),
      );

  @override
  void dispose() {
    phoneNumberController.dispose();
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
          Spacer(),
          ButtonWidget(text: "Next", onPressed: _onPressMethod),
        ],
      ),
    );
  }
}
