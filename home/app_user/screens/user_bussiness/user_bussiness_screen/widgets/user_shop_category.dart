import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../../../constant/constant.dart';
import '../../../../widgets/product_detail.dart/screen/product_detail_screen.dart';
import '../../user_bussiness_seemore/user_see_more_detailscreen.dart';
import '../../user_bussiness_seemore/widgets/balance_appbar/widget_balance_appbar/add_cart_button.dart';

class UserShopCategory extends StatelessWidget {
  const UserShopCategory({
    super.key,
    required this.categoryList,
    required this.city,
    required this.subCity,
    required this.shopName,
    required this.shopNumber,
  });
  final List<String> categoryList;
  final String city;
  final String subCity;
  final String shopName;
  final String shopNumber;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: categoryList.length,
      itemBuilder: (BuildContext context, int i) {
        return FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection("Place")
              .doc(city)
              .collection("SubCity")
              .doc(subCity)
              .collection("Shop")
              .doc(shopNumber)
              .collection("Category")
              .doc(categoryList[i])
              .collection("Product")
              .limit(6)
              .orderBy("time")
              .get(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.data?.size == 0) {
              print("No collection");
              return const SizedBox();
            }
            if (!snapshot.hasData) {
              return const SizedBox(
                  height: 300,
                  child: Center(child: CircularProgressIndicator()));
            }
            return ListTile(
              tileColor: Colors.blue.withOpacity(0.02),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
              title: Text(categoryList[i].toUpperCase(),
                  style: Constant.categoryHeading),
              subtitle: Container(
                color: Colors.blue.withOpacity(0.03),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing: 10,
                        crossAxisCount: 3,
                      ),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        QueryDocumentSnapshot data = snapshot.data!.docs[index];
                        // var v = snapshot.data!.docs[index - 1]['priority'];

                        // String category = data['category'] ?? "";
                        String name = data['pro_name'] ?? "";
                        String price = data['pro_price'] ?? "";
                        // String userMail = data['user'] ?? "";
                        List urlImage = data['lis'] ?? [];
                        String productId = data['productId']  ??"";

                        return Column(children: [
                          Stack(
                            alignment: Alignment.topRight,
                            children: [
                              CachedNetworkImage(
                                imageUrl: urlImage[0],
                                imageBuilder: (context, imageProvider) =>
                                    GestureDetector(
                                  onTap: () {
                                 
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ProductDetailScreen(
                                              productId: productId,
                                          shopNumber: shopNumber,
                                          city: city,
                                          subCity: subCity,
                                          name: name,
                                          price: price,
                                          category: categoryList[i],
                                          urlImage: urlImage[0],
                                          // category: category,
                                          shopName: shopName,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.add_shopping_cart_outlined,
                                      color: Colors.white)),
                            ],
                          ),
                          Center(child: Text(name)),
                        ]);
                      },
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  UserSeeMoreDetailScreen(
                                category: categoryList[i],
                                city: city,
                                subCity: subCity,
                                bussinessNumber: "9995498550",
                                shopName: shopName,
                              ),
                            ),
                          );
                        },
                        child: const Text("See more")),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
