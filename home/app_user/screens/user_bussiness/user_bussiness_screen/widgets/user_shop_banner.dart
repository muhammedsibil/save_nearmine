import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/utility/utility.dart';

class UserShopBanner extends StatelessWidget {
  const UserShopBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: ScreenSize.size.width,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, -3), // top shadow offset
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: CachedNetworkImage(
        imageUrl:
            "https://cdn.shopify.com/s/files/1/0177/6995/5428/files/A_Quick_Guide_On_How_To_Dress_Up_In_9_Colors_This_Navratri_2021.jpg?v=1633152223",
        fit: BoxFit.cover,
      ),
    );
  }
}
