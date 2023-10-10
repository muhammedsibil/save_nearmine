import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_bussiness/screens/bussiness_screen/widgets/user_shop_cart.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';
import 'package:near_mine/home/home_screen.dart';
import 'package:near_mine/home/app_user/widgets/user_chat_Bussiness.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../find_city/provider/data.dart';
import '../../../../../upload_multiple_images/upload_multiple_images.dart';

import '../../../../../utility/utility.dart';
import '../../../../app_bussiness/screens/my_shop_screen/screens/my_order_accept_screen/my_order_accept_screen.dart';
import '../../../../app_bussiness/screens/my_shop_screen/screens/my_shop_screen/widgets/chat_list.dart';
import '../../../../widget/categories_shop.dart';
import '../../../../widget/call_screen.dart';
import '../../../../widget/chat_bar.dart';
import '../user_bussiness_seemore/widgets/bottom/user_cart_screen/user_cart_screen.dart';
import 'widgets/user_shop_bussiness.dart';
import 'widgets/user_shop_banner.dart';

class UserShopScreen extends StatefulWidget {
  const UserShopScreen({Key? key, this.bussinessName, this.bussinessNumber})
      : super(key: key);
  final String? bussinessName;
  final String? bussinessNumber;
  @override
  State<UserShopScreen> createState() => _UserShopScreenState();
}

class _UserShopScreenState extends State<UserShopScreen> {
  String city = "manjeri";

  String subCity = "elankur";

  String shopName = "shop name";
  var bussinessNumber = "44";
  String number = "9995498550";

  bool isOpenImageList = false;

  land() => FirebaseFirestore.instance
      .collectionGroup("Place")
      .where("city", isEqualTo: "Wandoor")
      .snapshots();

  findcity(city, subCity) => FirebaseFirestore.instance
      .collection("FindCity")
      .where("city", isEqualTo: "manjeri")
      .snapshots();

  // .then(
  shop(city, subCity, number) => FirebaseFirestore.instance
      .collection("Place")
      .doc(city)
      .collection("SubCity")
      .doc(subCity)
      .collection("Shop")
      .get();

  products(city, subCity, number) => FirebaseFirestore.instance
      .collection("Place")
      .doc(city)
      .collection("SubCity")
      .doc(subCity)
      .collection("Shop")
      .doc(number)
      .collection("Category")
      .doc("foodshop")
      .collection("Product")
      .orderBy("time")
      .get();

  getProducts() {
    FirebaseFirestore.instance
        .collection("Place")
        .doc(city)
        .collection("SubCity")
        .doc(subCity)
        .collection("Shop")
        .doc(bussinessNumber)
        .collection("Category")
        .get()
        .then((QuerySnapshot snapshot) {
      // QueryDocumentSnapshot data = snapshot.docs.iterator.current;

      // listCategory.add(data);
      FirebaseFirestore.instance
          .collection("Place")
          .doc(city)
          .collection("SubCity")
          .doc(subCity)
          .collection("Shop")
          .doc(bussinessNumber)
          .collection("Category")
          .doc("foodshop")
          .collection("Product")
          .get();
    });
  }

  final _textController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumber();
  }

  // bool _hasFocus = false;
  var shopNumber;
  getNumber() async {
    // stringValue
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      shopNumber = prefs.getString("stringValue");
    });
  }

  @override
  Widget build(BuildContext context) {
    var bussinessName = widget.bussinessName ?? "Bussiness name";
    bussinessNumber = widget.bussinessNumber ?? "Bussiness name";

    city = context.watch<CityModel>().city;
    subCity = context.watch<CityModel>().subCity;
    // number = context.watch<CityModel>().numberShop;
    bool isMessageOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    print(city);
    print("shopNumber");

    print("shopNumber $shopNumber");

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leadingWidth: 0,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(
                        8), // Set the border radius for the ripple effect
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(Icons.arrow_back, color: Colors.black),
                        CircleAvatar(
                            // radius: 7,
                            ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(bussinessName,
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                        color: Colors.black)),
              ],
            ),
            Spacer(),
            IconButton(
              onPressed: () {
// bussinessNumber
              },
              icon: Icon(
                Icons.call,
                color: Colors.black.withOpacity(0.5),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const UserShopBanner(),
              const SizedBox(
                height: 16,
              ),
              UserShopBussiness(
                  shopName: bussinessName, shopNumber: bussinessNumber),

              const SizedBox(
                height: 10,
              ),
              // insideShop(),
            ],
          ),
        ),
        bottomSheet:
            ChatBar(shopNumber: bussinessNumber, shopName: bussinessName,ownership:'Shop' ),
        floatingActionButton: const UserShopCartMessageIcon(
          isChatIcon: false,
        ));
  }

  // Widget insideShop() {
  //   return ExpansionTile(
  //     title: Text('Inside Shop'),
  //     subtitle: Text('15'),
  //     children: <Widget>[
  //       ListTile(
  //         title: Text('muhammed'),
  //         leading: CircleAvatar(),
  //       ),
  //       ListTile(
  //         title: Text('ali'),
  //         leading: CircleAvatar(),
  //       ),
  //     ],
  //   );
  // }

  categoryName(snapshot) {
    String p = snapshot.data!.docs.first.reference.path;
    final List<String> paths = p.split('/');
    var categoryProduct = paths[7];
  }
}
