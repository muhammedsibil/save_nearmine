import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_up/sign_up_form_widget.dart';
import 'package:near_mine/authentication/sign_up/sign_up_phone_number/sign_up_phone_number_widget.dart';

import '../sign_up_password/sign_up_password_widget.dart';

class SignUpPhoneNumberScreen extends StatelessWidget {
  const SignUpPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpPhoneNumberWidget(),
    );
  }
}
