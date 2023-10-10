import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/data_model/user.dart';
import 'package:near_mine/home/search_city/search_city_screen.dart';
import 'package:near_mine/home/widget/call_screen.dart';
import 'package:near_mine/home/app_bussiness/screens/my_shop_screen/screens/my_shop_screen/my_shop_screen.dart';
import 'package:near_mine/home/widget/status_tab.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../find_city/provider/data.dart';
import '../main.dart';
import 'app_bussiness/screens/bussiness_screen/bussiness_screen.dart';
import 'app_bussiness/screens/product_upload_screen/product_upload.dart';
import 'app_user/screens/user_bussiness/user_job_screen/user_job_tab_screen.dart';
import 'app_vehicle/screens/my_vehicle_screen.dart/my_vehicle_screen.dart';
import 'app_vehicle/screens/vehicle_tab_screen/vehicles_tab_screen.dart';
import 'list_view/list_view_widget.dart';
import 'list_view/shops.dart';
import 'search_city/search_sub_city_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String city = context.watch<CityModel>().city;

    String subCity = context.watch<CityModel>().subCity;

    return Scaffold(
      appBar: AppBar(
        title: ListTile(
          title: Text('${context.watch<CityModel>().subCity}'),
          subtitle: Text('${context.watch<CityModel>().city}'),
        ),
        // actions: [
        //   IconButton(
        //           onPressed: () async {
        //             service.signOut(context);
        //             SharedPreferences pref =
        //                 await SharedPreferences.getInstance();
        //             pref.remove("email");
        //           },
        //           icon: Icon(Icons.logout)),
        // ],
      ),
      body: SingleChildScrollView(
        child: ListViewWidget(),
        // child: Shops(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({
    Key? key,
    this.subCity,
  }) : super(key: key);
  final String? subCity;
  @override
  Widget build(BuildContext context) {
    String city = context.watch<CityModel>().city;
    // context.read<CityModel>().addCity(city, subCity.toString());

    String ownership = context.watch<CityModel>().ownership;
    String shopName = context.watch<CityModel>().nameShop;
    print("ddddddddddddddddddddddddddddddddddddddddddd");
    print(shopName);
    if (ownership == "Bussiness") {
      return BussinessTab();
    } else if (ownership == "User") {
      return UserTab();
    } else if (ownership == "Vehicle") {
      return VehicleTab();
    } else {
      return SizedBox();
    }
  }
}

class CameraTab extends StatefulWidget {
  @override
  State<CameraTab> createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Icon(Icons.camera),
    );
  }
}

class BussinessTab extends StatelessWidget {
  const BussinessTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            '${context.watch<CityModel>().subCity}',
            style: TextStyle(color: Colors.black),
          ),
          // centerTitle: false,
          // backgroundColor: Colors.green,
          bottom: TabBar(
            isScrollable: true,

            onTap: ((value) {
              print(value);
            }),
            // controller: DefaultTabController.of(context),
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.business_outlined),
              ),
              Tab(
                text: "MY SHOP",
              ),
              Tab(
                text: "VEHICLES",
              ),
              Tab(
                text: "WORKERS",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
            ),
          ],
        ),
        body: TabBarView(
          // controller: DefaultTabController.of(context),
          children: <Widget>[
            BussinesScreen(),
            MyShopScreen(),
            VehiclesTabScreen(),
            UserJobTabScreen(),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   child: Icon(Icons.chat),
        //   onPressed: () {
        //     Navigator.push(
        //       context,
        //       MaterialPageRoute(builder: (context) => ProductUpload()),
        //     );
        //   },
        //   backgroundColor: primaryColor,
        // ),
      ),
    );
  }
}

class UserTab extends StatelessWidget {
  const UserTab({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,

          leading: IconButton(
            icon: Icon(
              Icons.location_city,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchSubCityScreen(),
                  // transitionsBuilder:
                  //     (context, animation, secondaryAnimation, child) {
                  //   var begin = Offset(0.0, 1.0);
                  //   var end = Offset.zero;
                  //   var curve = Curves.ease;

                  //   var tween = Tween(begin: begin, end: end)
                  //       .chain(CurveTween(curve: curve));

                  //   return SlideTransition(
                  //     position: animation.drive(tween),
                  //     child: child,
                  //   );
                  // },
                ),
              );
            },
          ),
          title: Text(
            Provider.of<CityModel>(context, listen: false).subCity,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          // centerTitle: false,
          backgroundColor: Colors.white,
          bottom: TabBar(
            indicatorColor: Colors.black.withOpacity(0.5),
            labelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                text: "BUSINESS",
              ),
              Tab(
                text: "VEHICLES",
              ),
              Tab(
                text: "WORKERS",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert, color: Colors.black),
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            BussinesScreen(),
            VehiclesTabScreen(),
            UserJobTabScreen(),
            // CallsTab(),
          ],
        ),
      ),
    );
  }
}

class VehicleTab extends StatelessWidget {
  const VehicleTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: (() {
                Navigator.of(context).pop();
              }),
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Text(
            '${context.watch<CityModel>().subCity}',
            style: TextStyle(color: Colors.black),
          ),
          // centerTitle: false,
          // backgroundColor: Colors.green,
          bottom: TabBar(
            indicatorColor: Colors.black,
            labelColor: Colors.black,
            tabs: <Widget>[
              Tab(
                icon: Icon(Icons.business_outlined),
              ),
              Tab(
                text: "My Vehicle",
              ),
              Tab(
                text: "VEHICLE",
              ),
              Tab(
                text: "JOB",
              ),
            ],
          ),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.more_vert),
              color: Colors.black,
            ),
          ],
        ),
        body: TabBarView(
          children: <Widget>[
            BussinesScreen(),
            DriverStatus(),
            VehiclesTabScreen(),
            UserJobTabScreen(),
            // CallsTab(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.chat),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProductUpload(
                        categoryPass: "cate",
                      )),
            );
          },
          backgroundColor: primaryColor,
        ),
      ),
    );
  }
}
