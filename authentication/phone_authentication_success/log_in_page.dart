import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'otp_in_page.dart';

class LogPage extends StatefulWidget {
  const LogPage({Key? key}) : super(key: key);

  @override
  State<LogPage> createState() => _LogPageState();
}

class _LogPageState extends State<LogPage> {
  final phoneController = TextEditingController();

  bool showLoading = false;

  String verificationFailedMessage = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: showLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(13),
              child: Column(
                children: [
                  Spacer(),
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Phone Number",
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (phoneController.text.isNotEmpty &&
                          phoneController.text.length == 10) {
                        setState(() {
                          showLoading = true;
                        });
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: '+91${phoneController.text}',
                          verificationCompleted:
                              (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            setState(() {
                              verificationFailedMessage = e.code;
                            });
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            print(verificationId);
                            print("verificationId verificationId");
                           
                            Navigator.of(context).push(PageRouteBuilder(
                                pageBuilder: (_, __, ___) => OtpInPage(
                                    verificationId: verificationId,
                                    phoneController:
                                        phoneController.text.toString())));
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } else {
                        print("type valid number");
                      }
                    },
                    child: Text("SEND"),
                    // color: Colors.blue,
                    // textColor: Colors.white,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(verificationFailedMessage),
                  Spacer(),
                ],
              ),
            ),
    );
  }
}
