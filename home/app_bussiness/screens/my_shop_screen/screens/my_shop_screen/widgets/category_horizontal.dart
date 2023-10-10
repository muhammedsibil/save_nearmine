import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:near_mine/home/app_bussiness/screens/my_shop_screen/screens/my_shop_screen/widgets/category_edit.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../../../../../../app_user/screens/user_bussiness/user_bussiness_seemore/user_see_more_detailscreen.dart';
import '../../../../../provider/provider_bussiness.dart';
import '../../../../product_upload_screen/product_upload.dart';

class Shop {
  final String city;
  final String subCity;
  final String businessNumber;
  // Add other properties as needed

  Shop(
      {required this.city,
      required this.subCity,
      required this.businessNumber});
}

class CategoryHorizontal extends StatelessWidget {
  const CategoryHorizontal(
      {super.key,
      required this.categoryList,
      required this.city,
      required this.subCity,
      required this.shopName,
      required this.bussinessNumber});
  final List<String> categoryList;
  final String city;
  final String subCity;
  final String shopName;
  final String bussinessNumber;

  Color getRandomColor() {
    Random random = Random();
    int red = 158 +
        random.nextInt(20) -
        10; // Add or subtract a value between -10 and 10
    int green = 158 + random.nextInt(20) - 10;
    int blue = 158 + random.nextInt(20) - 10;
    return Color.fromRGBO(
      red.clamp(0,
          255), // Ensure the color values are within the valid range of 0-255
      green.clamp(0, 255),
      blue.clamp(0, 255),
      1,
    );
  }

  Color colorGet(String value) {
    Color color;
    switch (value) {
      case "red":
        color = Colors.red[100]!;
        break;
      case "green":
        color = Colors.green[100]!;
        break;
      case "blue":
        color = Colors.blue[100]!;
        break;
      case "yellow":
        color = Colors.yellow[100]!;
        break;
      default:
        color = Colors.black;
    }
    Color myBlue = HSLColor.fromColor(color)
        .withSaturation(0.2)
        .withLightness(0.7)
        .toColor();
    return myBlue;
  }

  @override
  Widget build(BuildContext context) {
    
    final shop =
        Shop(city: city, subCity: subCity, businessNumber: bussinessNumber);
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Place")
            .doc(city)
            .collection("SubCity")
            .doc(subCity)
            .collection("Shop")
            .doc(bussinessNumber)
            .collection("Category")
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return Stack(
            alignment: Alignment.topRight,
            children: [
              Container(
                height: 70,
                color: Colors.white,
              ),
              Positioned(
                top: 4,
                child: Container(
                  padding: EdgeInsets.only(right: 60),
                  width: ScreenSize.size.width,
                  // height: 110,
                  child: Container(
                    height: 50,
                    width: ScreenSize.size.width,
                    alignment: Alignment.topCenter,
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (BuildContext context, int index) {
                        final data = snapshot.data!.docs[index].data()
                            as Map<String, dynamic>;

                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: ((context) => UserSeeMoreDetailScreen(
                                      category: categoryList[index],
                                      city: city,
                                      subCity: subCity,
                                      bussinessNumber: bussinessNumber,
                                      uploadProduct: uploadProduct(
                                          category: categoryList[index],
                                          context: context),
                                      shopName: shopName,
                                    )),
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Color(data["color"]).withOpacity(0.4),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              height: 50,
                              child: Padding(
                                padding: EdgeInsets.all(
                                  3.0,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              data["category_name"].toString(),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    data["thumb_nail"] == null
                                        ? const SizedBox()
                                        : ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            child: Image.network(
                                              data["thumb_nail"].toString(),
                                              height: 40,
                                              width: 30,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryEditScreen(
                                snapshot: snapshot.data!,
                                shop: shop,
                                shopName:shopName,
                              )));
                },
                icon: const Icon(
                  Icons.edit,
                  color: Colors.grey,
                ),
              ),
            ],
          );
        });
  }

  Widget uploadProduct({category, categoryList, context}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        alignment: Alignment.center,
        child: const CircleAvatar(
          // minRadius: 13,
          maxRadius: 14,
          child: Icon(Icons.add),
        ),
      ),
      onTap: () {
        context.read<ProviderBussiness>().addCategory(category);
        context.read<ProviderBussiness>().addCategories(categoryList);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductUpload(
              categoryPass: category,
            ),
          ),
        );
      },
    );
  }
}
