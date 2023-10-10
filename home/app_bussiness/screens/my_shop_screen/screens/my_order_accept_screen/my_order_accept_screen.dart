import 'package:flutter/material.dart';
import 'package:near_mine/utility/utility.dart';

import 'widgets/customer_move.dart';
import 'widgets/my_order_accept.dart';

class MyOrderAcceptSceen extends StatelessWidget {
  const MyOrderAcceptSceen({
    super.key,
    required this.number,
  });
  final String number;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              MyOrderAccept(number: number),
              AppBar(
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (() => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CustomerMove(
                                        users: [
                                          for (var i = 0; i < 16; i++)
                                            User(
                                                name: "name$i",
                                                imageUrl: "imageUrl")
                                        ],
                                      )))),
                          icon: Icon(
                            Icons.people,
                            color: Colors.green.withOpacity(0.5),
                          ),
                        ),
                        const Text(
                          "13",
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
                backgroundColor: Colors.white,
                title: const Text(
                  "My orders",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                leading: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
