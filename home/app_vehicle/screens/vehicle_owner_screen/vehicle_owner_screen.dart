import 'dart:math';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/blink_container.dart';
import '../../../app_user/widgets/user_chat_Bussiness.dart';
import 'widgets/welcome_customer.dart';

class VehicleOwnerScreen extends StatefulWidget {
  const VehicleOwnerScreen(
      {super.key, required this.headName, required this.vehicleCategory});
  final String headName;
  final String vehicleCategory;
  @override
  State<VehicleOwnerScreen> createState() => _VehicleOwnerScreenState();
}

class _VehicleOwnerScreenState extends State<VehicleOwnerScreen> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
  }

  Future<void> launchPhoneDialer(String contactNumber) async {
    final Uri _phoneUri = Uri(scheme: "tel", path: contactNumber);
    try {
      await launchUrl(_phoneUri);
      // if (await canLaunch(_phoneUri.toString()))
      //   await launch(_phoneUri.toString());
    } catch (error) {
      throw ("Cannot dial");
    }
  }

  @override
  Widget build(BuildContext context) {
    print(_hasCallSupport);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black,
            icon: Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: Text(
          "${widget.vehicleCategory} ${widget.headName.toString()}",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 16.0),
                      child: const CircleAvatar(
                        backgroundImage:
                            NetworkImage("https://example.com/avatar.png"),
                        radius: 48.0,
                      ),
                    ),
                    const Text("Name"),
                    const Text("Email"),
                    const Text("Vehicle Number"),
                  ],
                ),
                Column(
                  children: [
                    // WelcomeCustomer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: ElevatedButton.icon(
                        onPressed: (() => launchPhoneDialer("+919995498550")),
                        icon: Icon(Icons.call),
                        label: Text("Call"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(height: 3),
            const SizedBox(height: 16.0),
            detailsOFDriver("Price per kilometer :",
                emoji: "\u20B9", value: " Rs 20/km"),
            detailsOFDriver("Driver Name :", emoji: "👨‍✈️", value: " rahul"),
            // detailsOFDriver("Online :", emoji: "\u{1F7E2}",value: " Available"),
            detailsOFDriver("Rating :", icons: Icons.star, value: " 5.0 "),
            const Divider(),
          ],
        ),
      ),
      bottomSheet: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white70,
          border: Border(
            top: BorderSide(
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
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child:
                      const UserChatBussiness(bussinessName: "bussinessName"),
                ),
              ),
            );
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
      ),
    );
  }

  Widget detailsOFDriver(String name,
      {String? emoji, IconData? icons, String? value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: icons != null
              ? Icon(
                  icons,
                  color: Colors.yellow,
                  size: 19,
                )
              : Center(
                  child: Text(emoji.toString(),
                      style:
                          TextStyle(fontSize: emoji == "\u{1F7E2}" ? 19 : 16)),
                ),
        ),
        const SizedBox(
          width: 4,
        ),
        Row(
          children: [
            Text(
              " $name",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.7)),
            ),
            if (value != null)
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.8),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
