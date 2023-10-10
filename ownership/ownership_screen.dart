import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:near_mine/data_model/user.dart';
import 'package:near_mine/find_city/find_city_screen.dart';
import 'package:near_mine/find_city/provider/data.dart';
import 'package:provider/provider.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detail_screen/detail_screen.dart';
import '../home/home_screen.dart';
import '../main.dart';
import '../widgets/bottom_widget.dart';

class OwnershipScreen extends StatefulWidget {
  const OwnershipScreen({Key? key}) : super(key: key);

  @override
  State<OwnershipScreen> createState() => _OwnershipScreenState();
}

class _OwnershipScreenState extends State<OwnershipScreen> {
  String selectedValue = "User";

  var ownership = [
    {
      "name": "User",
    },
    {
      "name": "Bussiness",
    },
    {
      "name": "Vehicle",
    }
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDynamicLinks();
    setNumber();
  }

  setNumber() async {
    var number = Provider.of<CityModel>(context, listen: false).numberShop;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? existingValue = prefs.getString('stringValue');
    if (existingValue != null) {
      // Replace existing value with new number
      prefs.setString('stringValue', number);
      print('Existing value replaced: $number');
    } else {
      // Value doesn't exist, set it for the first time
      prefs.setString('stringValue', number);
      print('New value set: $number');
    }
  }

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  Future<void> initDynamicLinks() async {
    dynamicLinks.onLink.listen((dynamicLinkData) {
      print("dynamicLinkData");
      print(dynamicLinkData);
      final Uri uri = dynamicLinkData.link;
      final queryParams = uri.queryParameters;
      if (queryParams.isNotEmpty) {
        String? productId = queryParams["id"];
        Navigator.pushNamed(context, dynamicLinkData.link.path, arguments: {
          "productId": (productId!),
        });
      } else {
        Navigator.pushNamed(
          context,
          dynamicLinkData.link.path,
        );
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height - 120,
            width: MediaQuery.of(context).size.width,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: SingleChildScrollView(child: ownerList()))),
        bottomSheet: GestureDetector(
          onTap: () {
            print("heeeeeee");
            selectedValue.isNotEmpty
                ? Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FindCityScreen()),
                  )
                : null;
          },
          child: Container(
            alignment: Alignment.center,
            height: 80,
            color: Color.fromRGBO(0, 0, 0, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: selectedValue.isNotEmpty
                            ? Text(
                                selectedValue,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              )
                            : SizedBox())),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget ownerList() {
    return ListView.builder(
      // reverse: true,
      itemCount: ownership.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),

      primary: false,
      itemBuilder: (context, index) {
        var data = ownership[index];
        String name = data['name'].toString();
        return GestureDetector(
          onTap: () {
            setState(() {
              selectedValue = name;
            });
            context.read<CityModel>().addOwnership(name);
            print(name);
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => HomeScreen()),
            // );
          },
          child: Container(
            decoration: BoxDecoration(
                color:

                    // color: loginUser!.email == data['user']
                    //     ? Colors.green.withOpacity(.1):

                    Colors.blue.withOpacity(.1),
                borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
                Spacer(),
                selectedValue == name ? Icon(Icons.done) : SizedBox(),
              ],
            ),
          ),
        );
      },

      // gridDelegate:
      //                       const SliverGridDelegateWithFixedCrossAxisCount(
      //                     crossAxisCount: 3,
      //                   ),
    );
  }
}
