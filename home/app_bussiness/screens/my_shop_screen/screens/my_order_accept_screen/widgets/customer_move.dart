import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

import 'package:flutter/rendering.dart';

import '../../../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';


class User {
  final String name;
  final String imageUrl;

  User({required this.name, required this.imageUrl});
}

class CustomerMove extends StatefulWidget {
  final List<User> users;

  const CustomerMove({super.key, required this.users});

  @override
  _CustomerMoveState createState() => _CustomerMoveState();
}

class _CustomerMoveState extends State<CustomerMove> {
  late Timer _timer;
  List<Offset> positions = [];
  final random = Random();
  @override
  void initState() {
    super.initState();

    // Initialize the list of positions for each user
    for (int i = 0; i < widget.users.length; i++) {
      positions.add(Offset(
        random.nextDouble() * 300, // x position
        random.nextDouble() * 300, // y position
      ));
    }

    // Start a timer that updates the positions every 50 milliseconds
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      if (mounted) {
        setState(() {
          // Update the positions for each user
          for (int i = 0; i < positions.length; i++) {
            positions[i] = positions[i] +
                Offset(
                  random.nextDouble() * 10 - 5, // x direction movement
                  random.nextDouble() * 10 - 5, // y direction movement
                );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: widget.users.asMap().entries.map((entry) {
          final index = entry.key;
          final user = entry.value;

          return AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            left: positions[index].dx, // x position
            top: positions[index].dy, // y position
            child: SizedBox(
              width: 100,
              height: 100,
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChatBScreen(
                        name: "",
                        ownerId: "",
                        ownerCategory: "Shop",
                      )));
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundImage: NetworkImage(user.imageUrl),
                    ),
                    const SizedBox(height: 8),
                    Text(user.name),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

