import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_up/sign_up_form_widget.dart';
import 'package:near_mine/authentication/sign_up/sign_up_password/sign_up_password_widget.dart';

class SignUpPasswordScreen extends StatelessWidget {
  const SignUpPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const SignUpPasswordWidget(),
    );
  }
}
