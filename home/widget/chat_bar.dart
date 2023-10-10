import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../find_city/provider/data.dart';
import '../../utility/utility.dart';
import '../app_user/screens/user_bussiness/user_job_screen/screen/widgets/blink_container.dart';

class ChatBar extends StatefulWidget {
  const ChatBar({super.key, required this.shopNumber, required this.shopName, required this.ownership});
  final String shopNumber;
  final String shopName;
  final String ownership;
  @override
  State<ChatBar> createState() => _ChatBarState();
}

class _ChatBarState extends State<ChatBar> {
  String _city = '';
  String _subcity = '';
  String _number = '';
  String _ownership = '';

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _city = prefs.getString('city') ?? '';
      _subcity = prefs.getString('subcity') ?? '';
      _number = prefs.getString('number') ?? '';

      _ownership = prefs.getString('ownership') ?? '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    var ownership = context.watch<CityModel>().ownership;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white70,
        border: Border(
          top: BorderSide(
            //                    <--- top side
            color: Colors.black.withOpacity(0.2),
            width: 0.5,
          ),
        ),
      ),
      height: 60,
      child: InkWell(
        // style: ButtonStyle(
        //     backgroundColor: MaterialStateProperty.all(Colors.white70.withOpacity(0.5))),
        onTap: () {
          print(_ownership);
          print("_ownership");
          print(widget.shopName);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatBScreen(
              name: widget.shopName,
              ownerId: widget.shopNumber,
              ownerCategory: widget.ownership,
            ),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(100)),
                  height: 30,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      children: [
                        BlinkContainer(),
                        const Text("Message"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 6,
              ),
              const Icon(
                Icons.send,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
