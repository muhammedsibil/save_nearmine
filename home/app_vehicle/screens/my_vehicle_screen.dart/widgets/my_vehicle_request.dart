import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../utility/utility.dart';
import '../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';

class MyVehicleRequest extends StatelessWidget {
  const MyVehicleRequest({super.key, this.requested, this.user});
  final requested;
  final user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        requested
            ? Row(
                children: [
                  const CircleAvatar(),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.toString(),
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "are you at stand?",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () {
                        var subCity = FirebaseFirestore.instance
                            .collection("Place")
                            .doc("manjeri")
                            .collection("SubCity")
                            .doc("elankur");
                        var request = subCity
                            .collection("VehicleRequest")
                            .doc("7907156601");
                        var msg = subCity
                            .collection("vehicles")
                            .doc("7907156601")
                            .collection("Users")
                            .doc("7907156601")
                            .collection("Messages");

                        msg.add({
                          "text": "Hi,i'm at stand,  tell delivery details?",
                          "timestamp": FieldValue.serverTimestamp()
                        });

                        request.update(
                          {
                            "requested_status": false,
                            'accepted_at': FieldValue.serverTimestamp(),
                          },
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatBScreen(
                                    name: '',
                                    ownerId: '7907156601',
                                    ownerCategory: 'vehicles',
                                  )),
                        );
                      },
                      child: const Text("Yes")),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(),
                      ),
                      Expanded(
                        child: Text(
                          "Have you Completed shibi's delivery?",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              ScreenSize.size.width / 3,
                              50)), // Set the minimum width to infinity and height to 50
                        ),
                        onPressed: () {
                          var d = FirebaseFirestore.instance
                              .collection("Place")
                              .doc("manjeri")
                              .collection("SubCity")
                              .doc("elankur")
                              .collection("VehicleRequest")
                              .doc("7907156601");

                          d.update({'requested_status': true}).onError(
                              (error, stackTrace) => null);
                        },
                        child: Text('Cancel'),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          var d = FirebaseFirestore.instance
                              .collection("Place")
                              .doc("manjeri")
                              .collection("SubCity")
                              .doc("elankur");
                          var msg = d
                              .collection("vehicles")
                              .doc("7907156601")
                              .collection("Users")
                              .doc("7907156601")
                              .collection("Messages");
                          msg.add({
                            "text": "Hi, Please give feedback",
                            "timestamp": FieldValue.serverTimestamp()
                          });
                          d
                              .collection("VehicleRequest")
                              .doc("7907156601")
                              .delete()
                              .then((value) =>
                                  {print("Document successfully deleted!")})
                              .catchError((error) =>
                                  {print("Error deleting document: $error")});
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(Size(
                              ScreenSize.size.width / 3,
                              50)), // Set the minimum width to infinity and height to 50
                        ),
                        child: const Text('Done'),
                      ),
                    ],
                  ),
                ],
              )
      ],
    );
  }
}
