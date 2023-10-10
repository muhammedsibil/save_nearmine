import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../../app_user/screens/user_bussiness/user_bussiness_screen/widgets/user_shop_banner.dart';
import '../../../../../widgets/bussiness_shop_owner.dart';
import '../../my_order_accept_screen/my_order_accept_screen.dart';
import 'chat_list.dart';
import 'my_order_count.dart';

class MyShopWidget extends StatelessWidget {
  const MyShopWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body:  SingleChildScrollView(
        child: Column(
          children: const [
            SizedBox(
              height: 10,
            ),
            UserShopBanner(),

            BussinessShopOwner(),

            SizedBox(
              height: 10,
            ),
            // insideShop(),
            SizedBox(
              height: 60,
            ),
            SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "hero4",
            backgroundColor: Colors.grey, // Set the background color to blue
            mini: true,
            child: const Icon(
              Icons.chat,
              size: 24.0,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatListScreen()),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            heroTag: "hero6",
            backgroundColor: Colors.green, // Set the background color to blue
            // mini: true,
            child: Stack(
              children: const [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white70,
                  size: 36.0,
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: MyOrdersCount(),
                ),
              ],
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //       builder: (context) => MyOrderAcceptSceen(number: number)),
              // );
            },
          ),
        ],
      ),
    );
  
  }
}