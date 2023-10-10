import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:near_mine/find_city/provider/data.dart';
import 'package:near_mine/home/app_vehicle/screens/my_vehicle_screen.dart/widgets/user_vehicle_requests.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/edit_details.dart';
import '../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/select_category.dart';
import '../my_vehicle_screen.dart';
import 'edit_vehicle_details.dart';
import 'my_vehicle_profile.dart';

var uploadProgressVehicle;

class MyVehicleScreen extends StatefulWidget {
  const MyVehicleScreen(
      {super.key, required this.headName, required this.jobCategory});
  final String headName;
  final String jobCategory;
  @override
  State<MyVehicleScreen> createState() => _MyVehicleScreenState();
}

class _MyVehicleScreenState extends State<MyVehicleScreen> {
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

  Future<void> _selectImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await _uploadImage(
        pickedFile.path,
      );
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadImage(
    String imagePath,
  ) async {
    // Get a reference to the Firebase Storage location
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file to Firebase Storage with progress percentage
    final task = ref.putFile(File(imagePath));

    final doc = FirebaseFirestore.instance
        .collection("Place")
        .doc("manjeri")
        .collection("SubCity")
        .doc("elankur")
        .collection("vehicles")
        .doc("7907156601");

    task.snapshotEvents.listen((event) async {
      uploadProgressVehicle = event.bytesTransferred / event.totalBytes;
    }, onError: (Object e) {
      print(task.snapshot);
      if (e is FirebaseException && e.code == 'canceled') {
        print('Upload canceled');
      }
    });

    // Wait for the upload task to complete
    await task;

    // Get the URL of the uploaded file
    final url = await ref.getDownloadURL();

    // Save the URL to Cloud Firestore

    await doc.update({
      'thumb_nail': url,
    });

    print(url);
  }

  @override
  Widget build(BuildContext context) {
    print(_hasCallSupport);
    bool isEdit = widget.jobCategory == "Add";

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, top: 10),
      child: Center(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Place")
              .doc("manjeri")
              .collection("SubCity")
              .doc("elankur")
              .collection("vehicles")
              .doc("7907156601")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return Text('No data found.');
            } else {
              DocumentSnapshot documentSnapshot = snapshot.data!;
              Map<String, dynamic> data =
                  documentSnapshot.data() as Map<String, dynamic>;
              final String thumbNail = data["thumb_nail"] ?? "";
              final String name = data["name_driver"] ?? "";
              final String price = data["price_driver"] ?? "";
              final String number = data["number_driver"] ?? "";

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              final model = Provider.of<CityModel>(context,
                                  listen: false);
                              model.isUploading = true;
                              _selectImage().whenComplete(
                                  () => model.isUploading = false);
                            },
                            child: Container(
                              // alignment: isEdit ? Alignment.center : null,
                              margin: !isEdit
                                  ? EdgeInsets.only(bottom: 16.0)
                                  : null,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(thumbNail),
                                radius: 50.0,
                                child: Provider.of<CityModel>(context,
                                            listen: false)
                                        .isUploading
                                    ? Center(
                                        child: Container(
                                          // alignment: Alignment.center,
                                          width: 36,
                                          child: LinearProgressIndicator(),
                                        ),
                                      )
                                    : null,
                              ),
                            ),
                          ),

                          if (isEdit)
                            Column(
                              children: [
                                vehicleProfileDetails(
                                    name, const Icon(Icons.person)),
                                vehicleProfileDetails(
                                    number, const Icon(Icons.call)),
                                vehicleProfileDetails(
                                    price, const Icon(Icons.money)),

                                // const Divider(
                                //   height: 7,
                                //   thickness: 6,
                                // ),
                              ],
                            ),

                          if (!isEdit) Text("Name : "),
                          if (!isEdit) Text("Mob Number : "),

                          if (!isEdit)
                            detailsOFDriver("Price per hour :",
                                emoji: "\u20B9", value: " Rs 100/hr"),
                          if (!isEdit)
                            detailsOFDriver("Worker Name :",
                                emoji: "👨‍💼", value: " rahul"),
                          // detailsOFDriver("Online :", emoji: "\u{1F7E2}",value: " Available"),
                          if (!isEdit)
                            detailsOFDriver("Rating :",
                                icons: Icons.star, value: " 5.0 "),
                          if (!isEdit) const Divider(),
                          // BottomPopUp()
                        ],
                      ),
                      if (isEdit)
                        Positioned(
                          top: 50,
                          right: 10,
                          child: EditVehicleDetails(),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'My status:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const MyVehicleStatus(),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Notification:',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 19.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  UserVehicleRequests(),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget vehicleProfileDetails(text, icon) {
    return SizedBox(
      height: 30,
      child: ListTile(
        // minVerticalPadding: 0,
        title: Text(
          text,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        leading: icon,
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
                  color: icons == Icons.star ? Colors.yellow : null,
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
