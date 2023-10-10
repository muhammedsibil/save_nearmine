import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../../utility/utility.dart';

class ChatBScreen extends StatefulWidget {
  const ChatBScreen({
    super.key,
    required this.name,
    required this.ownerId,
    required this.ownerCategory,
  });
  final String name;
  final String ownerId;
  final String ownerCategory;

  @override
  _ChatBScreenState createState() => _ChatBScreenState();
}

class _ChatBScreenState extends State<ChatBScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  Stream<QuerySnapshot>? _stream;
  late FocusNode _focusNode;
  late Timer _timer;
  bool keyboardActive = false;

  @override
  void initState() {
    super.initState();

    _focusNode = FocusNode();
    _timer = Timer(Duration(milliseconds: 510), () {
      _focusNode.requestFocus();
    });
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
          .collection(widget.ownerCategory)
          .doc(stringValue)
          .collection("Recievers")
          .doc(widget.ownerId)
          .collection("Messages")
          .orderBy("timestamp", descending: true)
          .limit(6)
          .snapshots();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();

    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      // resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white.withOpacity(.9),

      appBar: AppBar(
        backgroundColor: Colors.black87,
        leadingWidth: 0,
        automaticallyImplyLeading: false,

        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.pop(context);
        //     },
        //     icon: Icon(Icons.close)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.close)),
          CircleAvatar(),
          SizedBox(
            width: 10,
          ),
          Center(child: Text(widget.name)),
          Spacer()
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        physics: BouncingScrollPhysics(),
        // keyboardDismissBehavior:   ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Container(
              height: 430,
              child: StreamBuilder<QuerySnapshot>(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final messages = snapshot.data?.docs;

                  List<Widget> messageWidgets = [];

                  if (messages != null) {
                    for (var message in messages) {
                      if (message.data != null) {
                        final messageData =
                            (message.data)() as Map<String, dynamic>;
                        final messageText = messageData['text'];
                        final messageSender = messageData['sender'];

                        final messageTime = messageData['timestamp'];

                        String amOrPm = "";
                        int hourIn12HourFormat = 0;
                        int minuts = 0;
                        var now = DateTime.now();
                        if (now != null) {
                          int hour = now.hour;
                          minuts = now.minute;
                          hourIn12HourFormat = ((hour + 11) % 12) + 1;
                          if (now.hour <= 11) {
                            amOrPm = "AM";
                          } else {
                            amOrPm = "PM";
                          }
                        }
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

                        final messageWidget = Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 8),
                          child: Column(
                            crossAxisAlignment: messageSender == "User1"
                                ? CrossAxisAlignment.start
                                : CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: messageSender == "User1"
                                    ? EdgeInsets.only(right: 40)
                                    : EdgeInsets.only(left: 40),
                                child: Card(
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: messageText
                                                    .toString()
                                                    .length
                                                    .toDouble() <
                                                10
                                            ? 100
                                            : null,
                                        color: messageSender == "User1"
                                            ? Colors.white
                                            : Colors.blue.withOpacity(0.08),
                                        child: Padding(
                                          padding: const EdgeInsets.all(18.0),
                                          child: Text(
                                            "$messageText  ",
                                            style: TextStyle(
                                                color: Colors.black87
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 3,
                                        right: 16,
                                        child: Text(
                                          hourIn12HourFormat == 0 && minuts == 0
                                              ? ""
                                              : "${hourIn12HourFormat.toString()}.$minuts $amOrPm",
                                          style: TextStyle(
                                            color:
                                                Colors.black87.withOpacity(0.5),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                        messageWidgets.add(messageWidget);
                      }
                    }
                  }

                  return ListView.builder(
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messageWidgets.length,
                    itemBuilder: (context, index) {
                      return messageWidgets[index];
                    },
                  );
                },
              ),
            ),
            Container(
              color: Colors.grey[200],
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        // autofocus: keyboardActive,
                        focusNode: _focusNode,
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: "Enter message",
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        String? stringValue = prefs.getString('stringValue');

                        if (stringValue != null) {
                          var reciever = FirebaseFirestore.instance
                              .collection("Place")
                              .doc("manjeri")
                              .collection("SubCity")
                              .doc("elankur")
                              .collection(widget.ownerCategory)
                              .doc(stringValue)
                              .collection("Recievers")
                              .doc(widget.ownerId);
                          reciever.collection("Messages").add({
                            "text": _textController.text,
                            "sender": "9061615995",
                            "timestamp": FieldValue.serverTimestamp(),
                            "reciever_name": widget.name,
                            "reciever_number": widget.ownerId
                          });
                          reciever.set({
                            "last_message": _textController.text,
                            "timestamp": FieldValue.serverTimestamp(),
                            "reciever_name": widget.name,
                            "reciever_number": widget.ownerId
                          });
                        }

                        _textController.clear();
                        _scrollController
                            .jumpTo(_scrollController.position.minScrollExtent);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
