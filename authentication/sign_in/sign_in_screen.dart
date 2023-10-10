import 'package:flutter/material.dart';
import 'package:near_mine/authentication/sign_in/sign_in_form_widget.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SignInFormWidget(),
    );
  }
}
