import 'package:flutter/material.dart';

import '../../../../app_user/screens/user_bussiness/user_bussiness_seemore/widgets/bottom/user_cart_screen/user_cart_screen.dart';
import '../../my_shop_screen/screens/my_shop_screen/widgets/chat_list.dart';

class UserShopCartMessageIcon extends StatelessWidget {
  const UserShopCartMessageIcon({super.key, required this.isChatIcon});
  final bool isChatIcon;
  @override
  Widget build(BuildContext context) {
    var isActive = isChatIcon == false;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (!isActive)
          FloatingActionButton(
            heroTag: "hero2",
            backgroundColor: Colors.grey, // Set the background color to blue
            mini: true,

            child: const Icon(Icons.chat),
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
          heroTag: "hero1",
          backgroundColor: Colors.grey, // Set the background color to blue
          mini: false,

          child:const Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>const UserCartScreen()),
            );
          },
        ),
        if (isActive)
          const SizedBox(
            height: 50,
          ),
      ],
    );
  }
}
