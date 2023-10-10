import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'path_constant.dart';

class ProductPage extends StatefulWidget {
  final String? productId;
  const ProductPage({Key? key, this.productId}) : super(key: key);

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  @override
  Widget build(BuildContext context) {
    String? input = widget.productId;
    List<String> UrlId = input!.split(',');
    print(UrlId);
    print("fruits");
    return Scaffold(
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection("Place")
            .doc(UrlId[1])
            .collection("SubCity")
            .doc(UrlId[2])
            .collection("Shop")
            .doc(UrlId[3])
            .collection("Category")
            .doc(UrlId[4])
            .collection("Product")
            .where("pro_price", isEqualTo: UrlId[5])
            .get(),
        // .limit(6)
        // .orderBy("time")
        // .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.data?.size == 0) {
            print("No collection");
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 30),
                  child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back)),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Container(
                  alignment: Alignment.center,
                  // color: Colors.blue.withOpacity(0.03),
                  child: Container(
                      padding: EdgeInsets.all(16),
                      color: Colors.blue.withOpacity(0.03),
                      child: Text("Hey! link not available")),
                ),
              ],
            );
          }
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListTile(
            tileColor: Colors.blue.withOpacity(0.02),
            contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 6),
            subtitle: Container(
              color: Colors.blue.withOpacity(0.03),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      QueryDocumentSnapshot data = snapshot.data!.docs[index];
                      // var v = snapshot.data!.docs[index - 1]['priority'];

                      // String category = data['category'] ?? "";
                      String name = data['pro_name'] ?? "";
                      String price = data['pro_price'] ?? "";
                      // String userMail = data['user'] ?? "";
                      List urlImage = data['lis'] ?? [];
                      String shopName = data['nameShop'] ?? "";
                      String category = data['category'] ?? "";

                      print(data.data());
                      print("data");
                      return Column(children: [
                        CachedNetworkImage(
                          imageUrl: urlImage[0],
                          imageBuilder: (context, imageProvider) =>
                              GestureDetector(
                            onTap: () {
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (BuildContext context) =>
                              //         ProductDetailScreen(
                              //       name: name,
                              //       price: price,
                              //       category: categoryList[index],
                              //       uploadProduct: uploadProduct(
                              //           category: categoryList[i]),
                              //       urlImage: urlImage[0],
                              //       // category: category,
                              //       shopName: shopName,
                              //     ),
                              //   ),
                              // );
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
                              CircularProgressIndicator(),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        Center(child: Text(name)),
                      ]);
                    },
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (BuildContext context) =>
                      //         UserSeeMoreDetailScreen(
                      //       category: categoryList[i],
                      //       city: _city,
                      //       subCity: _subCity,
                      //       bussinessNumber: bussinessNumber,
                      //       uploadProduct:
                      //           uploadProduct(category: categoryList[i]),
                      //       shopName: shopName,
                      //     ),
                      //   ),
                      // );
                    },
                    child: Text("See more"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
