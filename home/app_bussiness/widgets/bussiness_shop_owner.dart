import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_bussiness/provider/provider_bussiness.dart';
import 'package:near_mine/home/app_bussiness/screens/product_upload_screen/product_upload.dart';
import 'package:near_mine/home/app_bussiness/screens/product_upload_screen/product_upload_test.dart';
import 'package:near_mine/home/app_bussiness/widgets/bussiness_see_more.dart';
import 'package:provider/provider.dart';

import '../../../constant/constant.dart';
import '../../../find_city/provider/data.dart';
import '../../app_user/screens/user_bussiness/user_bussiness_seemore/user_see_more_detailscreen.dart';
import '../../app_user/widgets/product_detail.dart/screen/product_detail_screen.dart';
import '../screens/detail_screen.dart';
import '../screens/my_shop_screen/screens/my_shop_screen/widgets/category_horizontal.dart';

class BussinessShopOwner extends StatefulWidget {
  const BussinessShopOwner({
    Key? key,
  }) : super(key: key);

  @override
  State<BussinessShopOwner> createState() => _BussinessShopOwnerState();
}

class _BussinessShopOwnerState extends State<BussinessShopOwner> {
  String _city = "";

  String _subCity = "";

  String shopName = "shop name";
  String number = "9995498550";
  var listt;
  bool jjj = false;
  @override
  void initState() {
    super.initState();
    final store = Provider.of<CityModel>(context, listen: false);
    _city = store.city;
    _subCity = store.subCity;
    vv();
    // getLists();
  }

  vv() async {
    print("heyoutside $ccategoryList");
  }

  List<String> ccategoryList = [];

  List<String> categoryList = [];
  Future<List> getLists() async {
    CollectionReference colRef = FirebaseFirestore.instance
        .collection("Place")
        .doc(_city)
        .collection("SubCity")
        .doc(_subCity)
        .collection("Shop")
        .doc("9995498550")
        .collection("Category");
    QuerySnapshot docSnap = await colRef.get();
    docSnap.docs.forEach(
      (elements) {
        categoryList.add(elements.id);

        if (categoryList.length == docSnap.docs.length) {
          context.read<ProviderBussiness>().addCategories(categoryList);
          setState(() {});
        }
      },
    );
    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
    // if (categoryList.length == 0) {
    //   print("No collection");
    //   return uploadProduct();
    // }
    // if (!categoryList.isNotEmpty) {
    //   return CircularProgressIndicator();
    // }

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Place")
            .doc(_city)
            .collection("SubCity")
            .doc(_subCity)
            .collection("Shop")
            .doc("9995498550")
            .collection("Category")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return uploadProduct();
          }

          List<String> categoryList = [];
          snapshot.data!.docs.forEach((doc) {
            categoryList.add(doc.id);
          });
          return Center(
            child: Column(
              children: [
                CategoryHorizontal(
                  categoryList: categoryList,
                  city: _city,
                  subCity: _subCity,
                  shopName: shopName,
                  bussinessNumber: "9995498550",
                ),
                ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: categoryList.length + 1,
                  itemBuilder: (BuildContext context, int i) {
                    if (i == 0) {
                      return IconButton(
                        onPressed: () {
                          context
                              .read<ProviderBussiness>()
                              .addCategory("Add category");
                          context
                              .read<ProviderBussiness>()
                              .addCategories(categoryList);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UploadScreen()
                                  // ProductUpload(categoryPass: "Add category"),
                                  ));
                        },
                        icon: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 1, vertical: 1),
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.shade300,
                            // minRadius: 13,
                            maxRadius: 40,
                            child: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                    }
                    i = i - 1;
                    return StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("Place")
                          .doc(_city)
                          .collection("SubCity")
                          .doc(_subCity)
                          .collection("Shop")
                          .doc("9995498550")
                          .collection("Category")
                          .doc(categoryList[i])
                          .collection("Product")
                          .limit(6)
                          .orderBy("time")
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<dynamic> snapshot) {
                        if (snapshot.data?.size == 0) {
                          return ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductUpload(
                                          categoryPass: "Add catogory"),
                                    ));
                              },
                              child: Text("Add"));
                        }
                        if (!snapshot.hasData) {
                          return Container(
                              height: 300,
                              child:
                                  Center(child: CircularProgressIndicator()));
                        }
                        return ListTile(
                          tileColor: Colors.blue.withOpacity(0.02),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                          title: Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Text(categoryList[i].toUpperCase(),
                                style: Constant.categoryHeading
                                    .copyWith(color: Colors.grey)),
                          ),
                          subtitle: Container(
                            color: Colors.blue.withOpacity(0.03),
                            padding: EdgeInsets.all(16),
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
                                  itemCount: snapshot.data!.docs.length + 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    if (index == 0) {
                                      print(categoryList[i]);

                                      return uploadProduct(
                                          category: categoryList[i],
                                          categoryList: categoryList);
                                    }
                                    QueryDocumentSnapshot data =
                                        snapshot.data!.docs[index - 1];
                                    Map<String, dynamic> dataMap =
                                        data.data() as Map<String, dynamic>;

                                    // var v = snapshot.data!.docs[index - 1]['priority'];

                                    // String category = data['category'] ?? "";
                                    String name = dataMap['pro_name'] ?? "";
                                    String price = dataMap['pro_price'] ?? "";
                                    // String userMail = data['user'] ?? "";
                                    List urlImage = dataMap['lis'] ?? [];
                                    String xx = dataMap['thumb_nail'] ?? "";

                                    // String thumbNail;
                                    // if (dataMap.containsKey('thumb_nail')) {
                                    //   thumbNail = data['thumb_nail'];
                                    // } else {
                                    //   thumbNail = "";
                                    // }

                                    String productId = data['productId'] ?? "";

                                    return Column(children: [
                                      Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: xx,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ProductDetailScreen(
                                                      productId: productId,
                                                      shopNumber: number,
                                                      city: _city,
                                                      subCity: _subCity,
                                                      name: name,
                                                      price: price,
                                                      category: categoryList[i],
                                                      uploadProduct:
                                                          uploadProduct(
                                                              category:
                                                                  categoryList[
                                                                      i]),
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
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircularProgressIndicator(),
                                            errorWidget:
                                                (context, url, error) =>
                                                    Icon(Icons.error),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                  Icons
                                                      .add_shopping_cart_outlined,
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
                                            city: _city,
                                            subCity: _subCity,
                                            bussinessNumber: "9995498550",
                                            uploadProduct: uploadProduct(
                                                category: categoryList[i]),
                                            shopName: shopName,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Text("See more")),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          );
        });
  }

  Widget uploadProduct({category, categoryList}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        alignment: Alignment.center,
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade400,
          // minRadius: 13,
          maxRadius: 14,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      onTap: () {
        if (category == null) {
        } else {
          context.read<ProviderBussiness>().addCategory(category);
          context.read<ProviderBussiness>().addCategories(categoryList);
        }
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
