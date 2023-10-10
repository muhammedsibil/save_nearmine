import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image_picker/image_picker.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:url_launcher/url_launcher.dart';

import '../../../../../../find_city/provider/data.dart';
import '../../../../../app_vehicle/screens/my_vehicle_screen.dart/widgets/my_vehicle_edit.dart';
import '../../../../../app_vehicle/screens/vehicle_owner_screen/widgets/welcome_customer.dart';

import '../../../../../widget/chat_bar.dart';
import 'widgets/blink_container.dart';
import 'widgets/chat_job_screen.dart';
import 'widgets/edit_details.dart';
import 'widgets/switching.dart';

class UserJobScreen extends StatefulWidget {
  const UserJobScreen(
      {super.key,
      required this.headName,
      required this.jobCategory,
      required this.userCity,
      required this.userSubCity,
      required this.number,
      required this.isMy,
      required this.ownership});

  final String headName;
  final String jobCategory;
  final String userCity;
  final String userSubCity;
  final String ownership;

  final String number;
  final bool isMy;
  @override
  State<UserJobScreen> createState() => _UserJobScreenState();
}

class _UserJobScreenState extends State<UserJobScreen> {
  bool _hasCallSupport = false;
  Future<void>? _launched;
  String _phone = '';
  String name = '';

  @override
  void initState() {
    super.initState();
    // Check for phone call support.
    canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) {
      setState(() {
        _hasCallSupport = result;
      });
    });
    fetchData();
  }

  bool statusAvailable = false;
  bool statusBusy = false;
  bool statusOff = false;
  String? number;
  String? category;
  String? price;
  String? rating;
  String? thumbNail;
  String? userNumber;

  void fetchData() async {
    FirebaseFirestore.instance
        .collection("Place")
        .doc(widget.userCity.trim())
        .collection("SubCity")
        .doc(widget.userSubCity.trim())
        .collection(widget.ownership)
        .doc(widget.number.trim())
        .snapshots()
        .listen((snapshot) {
      if (mounted) {
        if (snapshot.exists) {
          final data = snapshot.data() as Map<String, dynamic>;
          name = data["user_name"] ?? '';
          statusAvailable = data["switch_available"] ?? false;
          statusBusy = data["switch_busy"] ?? false;
          statusOff = data["switch_off"] ?? false;

          category = data["user_type"] ?? "";
          // final String status = data["user_status"] ?? "";
          number = data["user_id"] ?? "";

          price = data["user_price"] ?? "";
          rating = data["user_rating"] ?? "";
          thumbNail = data["thumb_nail"] ??
              "https://w0.peakpx.com/wallpaper/20/744/HD-wallpaper-black-pattern-black-design-modern.jpg";

          userNumber = data["user_number"] ?? "";
          setState(() {});
        }
      }
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

  Future<void> _selectImage(model) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      model.isUploading = true;

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
        .doc(widget.userCity.trim())
        .collection("SubCity")
        .doc(widget.userSubCity.trim())
        .collection(widget.ownership)
        .doc(widget.number.trim());

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

    final model = Provider.of<CityModel>(context, listen: false);
    model.isUploading = true;

    await doc.update({
      'thumb_nail': url,
    }).whenComplete(() => model.isUploading = false);

    print(url);
  }

  @override
  Widget build(BuildContext context) {
    print(_hasCallSupport);
    bool isEdit = widget.jobCategory == "Add";

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            color: Colors.black,
            icon: const Icon(Icons.arrow_back)),
        backgroundColor: Colors.white,
        title: ListTile(
            title: Text(
              name,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w500),
            ),
            subtitle: Text(widget.jobCategory,
                style: const TextStyle(color: Colors.grey, fontSize: 13))),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            // alignment: Alignment.bottomCenter,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                
                  // SizedBox(
                  //   height: 30,
                  // ),
                  widget.isMy ? const EditDetails() : SizedBox(),

                  Container(
                    alignment: isEdit ? Alignment.center : null,
                    margin: !isEdit ? EdgeInsets.only(bottom: 16.0) : null,
                    child: GestureDetector(
                      onTap: () {
                        final model =
                            Provider.of<CityModel>(context, listen: false);

                        _selectImage(model)
                            .whenComplete(() => model.isUploading = false);
                      },
                      child: Container(
                        // alignment: isEdit ? Alignment.center : null,
                        margin: !isEdit ? EdgeInsets.only(bottom: 16.0) : null,
                        child: (thumbNail != null)
                            ? CircleAvatar(
                                backgroundImage: NetworkImage(thumbNail!),
                                radius: 50.0,
                                child: Provider.of<CityModel>(context,
                                            listen: true)
                                        .isUploading
                                    ? Center(
                                        child: Container(
                                          // alignment: Alignment.center,
                                          width: 36,
                                          child: LinearProgressIndicator(),
                                        ),
                                      )
                                    : null,
                              )
                            : SizedBox(),
                      ),
                    ),
                  ),
                  

                  if (!isEdit)
                    Text(
                      name,
                      style: const TextStyle(fontSize: 14),
                    ),

                  const SizedBox(height: 16.0),
                  const Divider(height: 3),
                  const SizedBox(height: 16.0),
                  // if (isEdit)
                  //   Align(
                  //       alignment: Alignment.bottomRight,
                  //       child: IconButton(
                  //           onPressed: () {}, icon: Icon(Icons.edit))),
                  if (!isEdit)
                    detailsOFDriver("Price per hour :",
                        emoji: "\u20B9", value: price),
                  if (!isEdit)
                    detailsOFDriver("Worker Name :",
                        emoji: "👨‍💼", value: name),
                  // detailsOFDriver("Online :", emoji: "\u{1F7E2}",value: " Available"),
                  if (!isEdit)
                    detailsOFDriver("Rating :",
                        icons: Icons.star, value: rating),
                  if (!isEdit) const Divider(),
                  widget.isMy
                      ? Switching(
                          statusBusy: statusBusy,
                          statusAvailable: statusAvailable,
                          statusOff: statusOff,
                          db: FirebaseFirestore.instance
                              .collection("Place")
                              .doc(widget.userCity.trim())
                              .collection("SubCity")
                              .doc(widget.userSubCity.trim())
                              .collection("Jobs")
                              .doc(widget.number.trim()))
                      : const SizedBox()
                  // BottomPopUp()
                  ,
                ],
              ),
             
              if (!isEdit)
                Positioned(
                  right: 0,
                  top: 30,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          WelcomeCustomer(
                            statusBusy: statusBusy,
                            statusAvailable: statusAvailable,
                            statusOff: statusOff,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          if (!statusOff)
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: ElevatedButton.icon(
                                onPressed: (() =>
                                    launchPhoneDialer(userNumber!)),
                                icon: Icon(Icons.call),
                                label: Text("Call"),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
     
      bottomSheet: widget.isMy
          ? const SizedBox()
          : ChatBar(
              shopNumber: widget.number,
              shopName: widget.headName,
              ownership: 'Jobs'),
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
