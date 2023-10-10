import 'package:flutter/material.dart';

class UserChatBussiness extends StatelessWidget {
  const UserChatBussiness({Key? key, this.bussinessName}) : super(key: key);
  final String? bussinessName;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                bussinessName.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24.0,
                  color: Colors.blue,
                ),
              ),
            ),
            const Spacer(),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {},
            ),
            TextButton(
              child: const Text(
                'Close',
                style: TextStyle(color: Colors.white),
              ),
              // color: Colors.blue,
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
