import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../find_city/provider/data.dart';
import '../../ownership/ownership_screen.dart';
import 'home_in_page.dart';

class OtpInPage extends StatefulWidget {
  OtpInPage(
      {Key? key,  this.verificationId,  this.phoneController})
      : super(key: key);
  final String? verificationId;
  final String? phoneController;
  @override
  State<OtpInPage> createState() => _OtpInPageState();
}

class _OtpInPageState extends State<OtpInPage> {
  final otpController = TextEditingController();
  bool showLoading = false;
  String verificationFailedMessage = "";
  final FirebaseAuth auth = FirebaseAuth.instance;

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
                  const Spacer(),
                  TextField(
                    controller: otpController,
                    decoration: const InputDecoration(
                      hintText: "otp",
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        showLoading = true;
                      });
                      PhoneAuthCredential credential =
                          PhoneAuthProvider.credential(
                              verificationId: widget.verificationId??"",
                              smsCode: otpController.text);
// ?.uid
                      // Sign the user in (or link) with the credential
                      await auth.signInWithCredential(credential);
                      if (auth.currentUser != null) {
                        context
                            .read<CityModel>()
                            .addNumber(widget.phoneController??"");

                        Navigator.of(context).push(PageRouteBuilder(
                            pageBuilder: (_, __, ___) => const OwnershipScreen()));
                      }
                    },
                    child: Text("Verify"),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(verificationFailedMessage),
                  const Spacer(),
                ],
              ),
            ),
    );
  }
}
