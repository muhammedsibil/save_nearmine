import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_bussiness/screens/my_shop_screen/screens/my_shop_screen/widgets/my_shop_widget.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_screen/widgets/user_shop_banner.dart';
import 'package:near_mine/home/widget/chat_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../../chat_screen/chat_screen.dart';
import '../../../../../../find_city/provider/data.dart';
import '../../../../../../upload_multiple_images/upload_multiple_images.dart';
import '../../../../../home_screen.dart';
import '../../../../../widget/categories_shop.dart';
import '../../../../widgets/bussiness_shop_owner.dart';
import '../../../product_upload_screen/product_upload.dart';
import '../../../../../widget/call_screen.dart';
import '../my_order_accept_screen/my_order_accept_screen.dart';
import 'widgets/category_horizontal.dart';
import 'widgets/chat_list.dart';
import 'widgets/customers_list.dart';
import 'widgets/my_order_count.dart';

class MyShopScreen extends StatefulWidget {
  @override
  State<MyShopScreen> createState() => _MyShopScreenState();
}

class _MyShopScreenState extends State<MyShopScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
// CityModel model = CityModel();
  String city = "manjeri";

  String subCity = "elankur";

  String shopName = "shop name";
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
        .doc(number)
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
          .doc(number)
          .collection("Category")
          .doc("foodshop")
          .collection("Product")
          .get();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getProducts();
  }

  int a = 0;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // city = context.watch<CityModel>().city;
    // subCity = context.watch<CityModel>().subCity;

    print("city");
    print(subCity);

    return const MyShopWidget();
  }

  Widget insideShop() {
    return ExpansionTile(
      title: Text(
        'Customers',
        style: TextStyle(color: Colors.grey),
      ),
      subtitle: Row(
        children: [
          Icon(
            Icons.group,
            color: Colors.green,
            size: 15,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            '115',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
      children: <Widget>[
        ListTile(
          title: Text('muhammed'),
          leading: CircleAvatar(),
        ),
        ListTile(
          title: Text('ali'),
          leading: CircleAvatar(),
        ),
      ],
    );
  }

  Widget accountsShop() {
    return ExpansionTile(
      title: const Text(
        'Total Sales',
        style: TextStyle(color: Colors.grey),
      ),
      children: <Widget>[
        Container(
          // alignment: Alignment.bottomRight,
          color: Color(0xFFFFD700),
          // height: 30,
          width: double.infinity,
          child: ListTile(
            title: Align(
              alignment: Alignment.bottomRight,
              child: Text("Total sale"),
            ),
            subtitle: Align(
              alignment: Alignment.bottomRight,
              child: Text("RS: 5000"),
            ),
          ),
        ),
      ],
    );
  }

  categoryName(snapshot) {
    String p = snapshot.data!.docs.first.reference.path;
    final List<String> paths = p.split('/');
    var categoryProduct = paths[7];
  }
}

class _DoneIconPainter extends CustomPainter {
  final double strokeWidth;

  _DoneIconPainter({this.strokeWidth = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(3.0, 12.0)
      ..lineTo(10.0, 19.0)
      ..lineTo(21.0, 6.0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_DoneIconPainter oldDelegate) {
    return oldDelegate.strokeWidth != strokeWidth;
  }
}
