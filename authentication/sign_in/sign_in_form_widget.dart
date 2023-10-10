import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_up/sign_up_screen.dart';

import '../../constant/constant.dart';
import '../constant/heading_widget.dart';
import '../constant/text_field_widget.dart';

class SignInFormWidget extends StatefulWidget {
  const SignInFormWidget({Key? key}) : super(key: key);

  @override
  State<SignInFormWidget> createState() => _SignInFormWidgetState();
}

class _SignInFormWidgetState extends State<SignInFormWidget> {
  TextEditingController phoneNumberController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
 _onPressMethod ()   => 
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SignUpScreen()),
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
        const  HeadingWidget(heading: "Password"),
          const SizedBox(
            height: 8,
          ),
          TextFieldWidget(controller: passwordController, hint: "Password"),
          const SizedBox(
            height: 16,
          ),
          ButtonWidget(text: "Sign In",onPressed: _onPressMethod,),
        ],
      ),
    );
  }


}
