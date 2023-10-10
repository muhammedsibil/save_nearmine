import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';
import '../../../../../../widget/chat_bar.dart';

class ChatListScreen extends StatefulWidget {
  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  Stream<QuerySnapshot>? _stream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMessages();
  }

  getMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? stringValue = prefs.getString('stringValue');
    if (stringValue != null) {
      _stream = FirebaseFirestore.instance
          .collection("Place")
          .doc("manjeri")
          .collection("SubCity")
          .doc("elankur")
          .collection("User")
          .doc(stringValue)
          .collection("Recievers")
          .orderBy("timestamp", descending: true)
          .limit(6)
          .snapshots();
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          'My Chats',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context, index) {
                print(snapshot.data?.docs.length);
                print("object");
                QueryDocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic>? data =
                    document.data() as Map<String, dynamic>?;
                // var messageTime = data!["timestamp"];
                var messageTime = data!['timestamp'];
                final String? name = data!['reciever_name'];
                final String? number = data!['reciever_number'];
                Duration difference = Duration();
                bool isDate = false;

                if (messageTime != null && messageTime is Timestamp) {
                  final DateTime dateTime = messageTime.toDate();
                  difference = DateTime.now().difference(dateTime);
                  if (difference >= Duration(days: 1)) {
                    isDate = true;
                  }
                }

                String amOrPm = "";
                int hourIn12HourFormat = 0;
                int minuts = 0;

                var now = DateTime.now();
                if (messageTime != null && messageTime is Timestamp) {
                  int hour = messageTime.toDate().hour;
                  minuts = messageTime.toDate().minute;
                  hourIn12HourFormat = ((hour + 11) % 12) + 1;
                  if (messageTime.toDate().hour <= 11) {
                    amOrPm = "AM";
                  } else {
                    amOrPm = "PM";
                  }
                }
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(difference.toString()),
                  ),
                  // title: Text(
                  //   '${data!["reciever_name"]?.toString()}',
                  //   style: TextStyle(color: Colors.black),
                  // ),
                  title: Text(
                    "${data!["reciever_name"]?.toString()}",
                  ),
                  subtitle: Text('${data!["last_message"]?.toString()}'),
                  trailing: isDate
                      ? Text(
                          "${messageTime.toDate().day}/${messageTime.toDate().month}/${messageTime.toDate().year.toString().substring(2)}")
                      : Text(
                          hourIn12HourFormat == 0 && minuts == 0
                              ? ""
                              : "${hourIn12HourFormat.toString()}.$minuts $amOrPm",
                          style: TextStyle(
                            color: Colors.black87.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? stringValue = prefs.getString('stringValue');
                    if (stringValue != null) {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatBScreen(
                          name: name??"",
                          ownerId: number??"",
                          ownerCategory: "User",
                        ),
                      ));
                    }
                  },
                );
              },
            );
          }),
    );
  }
}
