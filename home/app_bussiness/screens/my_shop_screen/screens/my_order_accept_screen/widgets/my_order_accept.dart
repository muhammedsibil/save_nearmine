import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyOrderAccept extends StatefulWidget {
  const MyOrderAccept({
    Key? key,  required this.number,
  }) : super(key: key);
  final String number;
  @override
  State<MyOrderAccept> createState() => _MyOrderAcceptState();
}

class _MyOrderAcceptState extends State<MyOrderAccept>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  final orderInstance = FirebaseFirestore.instance;
  bool loading = false;
  int tapIndex = 0;
  var isInternet = false;
  @override
  initState() {
    super.initState();
    print("initState Called");
    internetCheck();
    print("initState Called");
  }

  internetCheck() async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      setState(() {
        isInternet = true;
        print("initState Called");
      });
    }
  }

  var isMove = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // print(widget.scrollController);
    // internetCheck();

    print("hi");
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection("Place")
          .doc("manjeri")
          .collection("SubCity")
          .doc("elankur")
          .collection("Shop")
          .doc(widget.number)
          .collection("Order")
          .limit(19)
          .orderBy("time", descending: true)
          .get(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.data?.size == 0) {
          return Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.width / 2,
                left: MediaQuery.of(context).size.width / 2.3),
            child: Row(
              children: [
                isInternet ? Text("No Orders") : Text("Connect Internet"),
              ],
            ),
          );
        }
        if (!snapshot.hasData) {
          return const Padding(
            padding: EdgeInsets.all(100.0),
            child: Center(
              child: SizedBox(
                  height: 30, width: 30, child: CircularProgressIndicator()),
            ),
          );
        }

        return Container(
          padding: EdgeInsets.only(top: 100),
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            // physics: NeverScrollableScrollPhysics(),

            // controller: widget.scrollControll,
            reverse: false,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot data = snapshot.data!.docs[index];
              final List h = data["order"].toList() ?? [];
              final String nameShop = data["nameShop"] ?? "name";
              final String userName = data["userName"] ?? "name";
              final String orderRequist = data["orderRequist"] ?? "name";

              return Container(
                margin: const EdgeInsets.all(4),
                color: Colors.white.withOpacity(1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(userName.toString()),
                    Text(nameShop.toString()),
                    Container(
                      margin: EdgeInsets.all(10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: orderRequist == "accepted"
                                ? Colors.green
                                : null,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold)),
                        child: orderRequist == "accepted"
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (tapIndex == index)
                                    loading == true
                                        ? Column(
                                            children: [
                                              const CircularProgressIndicator(
                                                strokeWidth: 1,
                                                color: Colors.white,
                                              ),
                                            ],
                                          )
                                        : const SizedBox(),
                                  const SizedBox(width: 10),
                                  loading == true
                                      ? tapIndex == index
                                          ? Text("Loading..")
                                          : const Text("Accepted")
                                      : const Text("Accepted"),
                                ],
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (tapIndex == index)
                                    loading == true
                                        ? const CircularProgressIndicator(
                                            strokeWidth: 1, color: Colors.white)
                                        : const SizedBox(),
                                  const SizedBox(width: 10),
                                  loading == true
                                      ? (tapIndex == index)
                                          ? Text("Loading..")
                                          : const Text("Accept")
                                      : const Text("Accept"),
                                ],
                              ),
                        onPressed: () async {
                          try {
                            final result =
                                await InternetAddress.lookup('example.com');
                            if (result.isNotEmpty &&
                                result[0].rawAddress.isNotEmpty) {
                              setState(() {
                                tapIndex = index;
                                loading = true;
                              });

                              if (data.exists) {
                                data.reference
                                    .update({
                                      'orderRequist': orderRequist == "accepted"
                                          ? 'not_accepted'
                                          : 'accepted'
                                    })
                                    .then((_) => setState(() {
                                          loading = false;
                                        }))
                                    .catchError((error) =>
                                        print('Update failed: $error'));
                              }
                            }
                          } on SocketException catch (_) {
                            return showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    AlertDialog(
                                      title:
                                          const Text('No internet available.'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),

                    // Wrap(
                    //   spacing: 0,
                    //   runSpacing: 0,
                    //   children: h
                    //       .map((e) => SizedBox(
                    //             height: 100,
                    //             width: 70,
                    //             child: Column(
                    //               crossAxisAlignment:
                    //                   CrossAxisAlignment.start,
                    //               children: [
                    //                 Image.network(
                    //                   e["image"],
                    //                   fit: BoxFit.cover,
                    //                   // width: 50,
                    //                   // height: 50,
                    //                 ),
                    //                 Text(e["name"].toString(),
                    //                     style: TextStyle(
                    //                         fontSize: 14,
                    //                         overflow: TextOverflow.fade)),
                    //                 Text(e["totalPrice"].toString()),
                    //               ],
                    //             ),
                    //           ))
                    //       .toList(),
                    // ),
                    SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: h.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.network(
                                  h[index]["image"],
                                  fit: BoxFit.cover,
                                  // width: 60,
                                  height: 60,
                                ),
                                Flexible(
                                  child: Text(
                                    h[index]["name"].toString(),
                                    style: TextStyle(
                                      fontSize: 14,
                                      // overflow: TextOverflow.ellipsis
                                    ),
                                  ),
                                ),
                                Flexible(
                                    child: Text(
                                        h[index]["totalPrice"].toString())),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
