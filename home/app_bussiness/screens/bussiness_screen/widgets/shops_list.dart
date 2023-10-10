import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:near_mine/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../../../../constant/constant.dart';
import '../../../../../find_city/provider/data.dart';
import '../../../../app_user/screens/user_bussiness/user_bussiness_screen/user_shop_screen.dart';
import '../../my_shop_screen/screens/my_shop_screen/my_shop_screen.dart';

class ShopsList extends StatefulWidget {
  const ShopsList({
    Key? key,
    this.child,
  }) : super(key: key);
  final Widget? child;
  @override
  State<ShopsList> createState() => _ShopsListState();
}

class _ShopsListState extends State<ShopsList> {
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<CityModel>(context, listen: false);
    var _city = store.city;
    var _subCity = store.subCity;
    return Column(
      children: [
        FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("Place")
              .doc(_city)
              .collection("SubCity")
              .doc(_subCity)
              .collection("Shop")
              .limit(6)
              .get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data?.size == 0) {
              print("No collection");
              // return uploadProduct(category: categoryList[i]);
            }
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      print(index);
                      return SizedBox();
                    }
                    QueryDocumentSnapshot data = snapshot.data!.docs[index - 1];

                    String bussiness_name = data['name'] ?? "";
                    String bussiness_number = data['number'] ?? "";

                    return ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserShopScreen(
                                bussinessName: bussiness_name,
                                bussinessNumber: bussiness_number),
                          ),
                        );
                      },
                      title: SizedBox(
                        height: 60,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const CircleAvatar(
                              backgroundColor: Constant.PRIMARY_BLACK,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bussiness_name,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.group,
                                        size: 14, color: Colors.green.shade300),
                                    const SizedBox(width: 4),
                                    const Text(
                                      "13",
                                      style: TextStyle(
                                          // color: Colors.green.shade300,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            Container(
                              height: 50,
                              color: Colors.white,
                              child: Image.network(
                                "https://cdn.shopify.com/s/files/1/0177/6995/5428/files/A_Quick_Guide_On_How_To_Dress_Up_In_9_Colors_This_Navratri_2021.jpg?v=1633152223",
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                TextButton(onPressed: () {}, child: Text("See more")),
              ],
            );
          },
        )
      ],
    );
  }
}
