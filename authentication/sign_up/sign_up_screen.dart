import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_up/sign_up_form_widget.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SignUpFormWidget(),
    );
  }
}
