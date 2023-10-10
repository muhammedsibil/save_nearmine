import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_user/widgets/product_detail.dart/screen/widgets.dart/product_detail.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../../constant/constant.dart';
import '../../../../../utility/utility.dart';
import '../../../models/product_model.dart';
import '../../../provider/provider_user.dart';
import '../../../screens/user_bussiness/user_bussiness_seemore/user_see_more_detailscreen.dart';
import '../../../screens/user_bussiness/user_bussiness_seemore/widgets/balance_appbar/widget_balance_appbar/add_cart_button.dart';
import '../../../screens/user_bussiness/user_bussiness_seemore/widgets/bottom/bottom_widget.dart';
import '../../../screens/user_bussiness/user_job_screen/screen/user_job_screen.dart';
import 'widgets.dart/description.dart';
import 'widgets.dart/review.dart';
import 'widgets.dart/share_product.dart';

class ProductDetailScreen extends StatefulWidget {
  final String category;
  final String name;
  final String price;
  final Widget? uploadProduct;
  final String urlImage;
  final String shopName;
  final String shopNumber;
  final String city;
  final String subCity;
  final String productId;
  const ProductDetailScreen(
      {Key? key,
      required this.category,
      required this.name,
      required this.price,
      required this.urlImage,
      this.uploadProduct,
      required this.shopName,
      required this.shopNumber,
      required this.city,
      required this.subCity,
      required this.productId})
      : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool b = false;
 
  @override
  void initState() {
    super.initState();
  }

  var scrollController = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> product = [
      {
        "name": widget.name,
        "image": widget.urlImage,
        "proWeightUnit": "proWeightUnit",
        "price": widget.price,
        "shopName": widget.shopName,
        "number": widget.shopNumber,
        "productId": widget.productId,
      }
    ];
    print("hy ${widget.shopName}");
    // context.read<ProviderUser>().addWeight(product);
    // List<Map<String, dynamic>> ppp = context.watch<ProviderUser>().product;
    // List<Map<String, dynamic>> product = context.watch<ProviderUser>().product;
    var isProductDetails =
        (Provider.of<ProviderUser>(context, listen: false).isProductDetails);
    return WillPopScope(
      onWillPop: () async {
        print('Back button was tapped');
        Provider.of<ProviderUser>(context, listen: false)
            .boolIsProductDetails(false);
        return true; // return true to pop the route
      },
      child: SafeArea(
        child: Scaffold(
            body: Scrollbar(
              controller: scrollController,
              child: CustomScrollView(
                primary: false,
                controller: scrollController,
                slivers: <Widget>[
                  ProductDetail(
                    category: widget.category,
                    city: widget.city,
                    name: widget.name,
                    price: widget.price,
                    product: product,
                    shopName: widget.shopName,
                    shopNumber: widget.shopNumber,
                    subCity: widget.subCity,
                    urlImage: widget.urlImage,
                    productId: widget.productId,
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        isProductDetails
                            ? const SizedBox()
                            : FutureBuilder<QuerySnapshot>(
                                future: FirebaseFirestore.instance
                                    .collection("Place")
                                    .doc(widget.city)
                                    .collection("SubCity")
                                    .doc(widget.subCity)
                                    .collection("Shop")
                                    .doc(widget.shopNumber)
                                    .collection("Category")
                                    .doc(widget.category)
                                    .collection("Product")
                                    .limit(30)
                                    .orderBy("time")
                                    .get(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<dynamic> snapshot) {
                                  if (snapshot.data?.size == 0) {
                                    print("No collection");
                                    return const SizedBox();
                                    // return uploadProduct(category: categoryList[i]);
                                  }
                                  if (!snapshot.hasData) {
                                    return const SizedBox(
                                        height: 190,
                                        child: Center(
                                            child:
                                                CircularProgressIndicator()));
                                  }
                                  return ListTile(
                                    tileColor: Colors.blue.withOpacity(0.02),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 6),
                                    title: Column(
                                      // mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text("ALL",
                                            style: Constant.categoryHeading),
                                        Text(widget.category.toUpperCase(),
                                            style: Constant.categoryHeading
                                                .copyWith(
                                                    color: Colors.black38)),
                                      ],
                                    ),
                                    subtitle: Container(
                                      color: Colors.blue.withOpacity(0.03),
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          GridView.builder(
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            gridDelegate:
                                                const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisSpacing: 10,
                                              crossAxisCount: 3,
                                              childAspectRatio: 1 / 1.3,
                                              // mainAxisSpacing: 100,
                                            ),
                                            itemCount:
                                                snapshot.data!.docs.length + 1,
                                            itemBuilder: (BuildContext context,
                                                int index) {
                                              if (index == 0) {
                                                print(widget.category);
                                                return const SizedBox();
                                                // return uploadProduct(category: categoryList[i]);
                                              }
                                              QueryDocumentSnapshot data =
                                                  snapshot
                                                      .data!.docs[index - 1];
                                              // var v = snapshot.data!.docs[index - 1]['priority'];

                                              // String category = data['category'] ?? "";
                                              String name =
                                                  data['pro_name'] ?? "";
                                              String price =
                                                  data['pro_price'] ?? "";
                                              // String userMail = data['user'] ?? "";
                                              List urlImage = data['lis'] ?? [];
                                              String shopName =
                                                  data['nameShop'] ?? "";
                                              String category =
                                                  data['category'] ?? "";
                                              String number =
                                                  data['number'] ?? "";

                                              print(data.data());
                                              print("data");

                                              return Column(children: [
                                                CachedNetworkImage(
                                                  imageUrl: urlImage[0],
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      GestureDetector(
                                                    onTap: () {
                                                      Provider.of<ProviderUser>(
                                                              context,
                                                              listen: false)
                                                          .boolIsProductDetails(
                                                              true);
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (BuildContext
                                                                  context) =>
                                                              ProductDetailScreen(
                                                            productId: widget
                                                                .productId,
                                                            shopNumber: number,
                                                            city: widget.city,
                                                            subCity:
                                                                widget.subCity,
                                                            name: name,
                                                            price: price,
                                                            category:
                                                                widget.category,
                                                            // uploadProduct: uploadProduct(
                                                            //     category:
                                                            //         categoryList[i]),
                                                            urlImage:
                                                                urlImage[0],
                                                            // category: category,
                                                            shopName: shopName,
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 80,
                                                      alignment:
                                                          Alignment.center,
                                                      decoration: BoxDecoration(
                                                        color: Colors.amber,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
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
                                                Center(
                                                    child: Column(
                                                  children: [
                                                    Text(name),
                                                    Text('RS: $price',
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                Colors.grey)),
                                                  ],
                                                )),
                                              ]);
                                            },
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (BuildContext
                                                          context) =>
                                                      UserSeeMoreDetailScreen(
                                                    category: widget.category,
                                                    city: widget.city,
                                                    subCity: widget.subCity,
                                                    bussinessNumber:
                                                        widget.shopNumber,
                                                    // uploadProduct: uploadProduct(
                                                    //     category: widget.category),
                                                    shopName: widget.shopName,
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text("See more"),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomSheet: BottomWidget()),
      ),
    );
    // body: SingleChildScrollView(
    //   child: Column(
    //     children: [

    // AppBar(
    //   automaticallyImplyLeading: false,
    //   toolbarHeight: 450,
    //   actions: [
    //     CachedNetworkImage(
    //       height: 300,
    //       width: MediaQuery.of(context).size.width,
    //       imageUrl: widget.urlImage,
    //       imageBuilder: (context, imageProvider) => Container(
    //         alignment: Alignment.center,
    //         decoration: BoxDecoration(
    //           color: Colors.amber,
    //           borderRadius: BorderRadius.circular(15),
    //           image: DecorationImage(
    //             image: imageProvider,
    //             fit: BoxFit.cover,
    //           ),
    //         ),
    //       ),
    //       placeholder: (context, url) =>
    //           CircularProgressIndicator(),
    //       errorWidget: (context, url, error) => Icon(Icons.error),
    //     ),
    //   ],
    // ),
    // Padding(
    //   padding: EdgeInsets.symmetric(
    //       vertical: 8.0,
    //       horizontal: widget.name.length > 16 ? 8 : 16.0),
    //   child: Container(
    //     // color: Colors.blue.shade100.withOpacity(0.10),

    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.end,
    //       children: [
    //         Row(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   width: widget.name.length > 16 ? 240 : null,
    //                   child: Text(
    //                     "${widget.name}",
    //                     style: Business.headline5,
    //                     maxLines: 2,
    //                     overflow: TextOverflow.ellipsis,
    //                   ),
    //                 ),
    //                 const SizedBox(
    //                   height: 6,
    //                 ),
    //                 Text(
    //                   "₹${widget.price}",
    //                   style: Business.headline5.copyWith(
    //                       color: Colors.black.withOpacity(0.6),
    //                       fontSize: 24),
    //                 ),
    //               ],
    //             ),
    //             const Spacer(),
    //             ShareProduct(
    //                 number: widget.shopNumber,
    //                 city: widget.city,
    //                 subCity: widget.subCity,
    //                 price: widget.price,
    //                 category: widget.category,
    //                 urlImage: widget.urlImage),
    //           ],
    //         ),

    //         Row(
    //           children: [
    //             const Spacer(),
    //             AddtoCartButton(
    //               product: product,
    //               totalValue: double.parse(widget.price),
    //               proTotalWeight: "proTotalWeight",
    //               weightUnit: "weightUnit",
    //               itemCount: 1,
    //               width: 130,
    //               height: 60,
    //             ),
    //           ],
    //         ), //about product desc

    //         Container(
    //           // height: 30,
    //           padding: const EdgeInsets.all(10),
    //           decoration: BoxDecoration(
    //             // color: Colors.blue,
    //             border: Border(
    //                 bottom: BorderSide(
    //                     color: Colors.blueGrey.withOpacity(0.3))),
    //           ),
    //           alignment: Alignment.center,
    //           child: Row(
    //             mainAxisAlignment: MainAxisAlignment.spaceAround,
    //             children: [
    //               Description(name: widget.name),
    //               Review(name: widget.name),

    //               // Image.network(widget.urlImage,height: 30,width: 30,),
    //               Column(
    //                 children: [
    //                   Icon(Icons.delivery_dining),
    //                   Text(
    //                     "Free Delivery",
    //                     style: TextStyle(
    //                       fontSize: 10,
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             ],
    //           ),
    //         ),

    //         //  SizedBox(
    //         //   height: 600,
    //         //    child: UserSeeMoreDetailScreen(
    //         //                       category: widget.category,
    //         //                       city: widget.city,
    //         //                       subCity: widget.subCity,
    //         //                       bussinessNumber: widget.shopNumber,
    //         //                       // uploadProduct: uploadProduct(
    //         //                       //     category: widget.category),
    //         //                       shopName: widget.shopName,
    //         //                     ),
    //         //  ),
    //       ],
    //     ),
    //   ),
    // ),
    // FutureBuilder<QuerySnapshot>(
    //   future: FirebaseFirestore.instance
    //       .collection("Place")
    //       .doc(widget.city)
    //       .collection("SubCity")
    //       .doc(widget.subCity)
    //       .collection("Shop")
    //       .doc(widget.shopNumber)
    //       .collection("Category")
    //       .doc(widget.category)
    //       .collection("Product")
    //       .limit(6)
    //       .orderBy("time")
    //       .get(),
    //   builder:
    //       (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
    //     if (snapshot.data?.size == 0) {
    //       print("No collection");
    //       return const SizedBox();
    //       // return uploadProduct(category: categoryList[i]);
    //     }
    //     if (!snapshot.hasData) {
    //       return CircularProgressIndicator();
    //     }
    //     return ListTile(
    //       tileColor: Colors.blue.withOpacity(0.02),
    //       contentPadding:
    //           EdgeInsets.symmetric(vertical: 16, horizontal: 6),
    //       title: Text(widget.category.toUpperCase(),
    //           style: Constant.categoryHeading),
    //       subtitle: Container(
    //         color: Colors.blue.withOpacity(0.03),
    //         padding: EdgeInsets.all(16),
    //         child: Column(
    //           children: [
    //             GridView.builder(
    //               physics: const NeverScrollableScrollPhysics(),
    //               shrinkWrap: true,
    //               gridDelegate:
    //                   const SliverGridDelegateWithFixedCrossAxisCount(
    //                 crossAxisSpacing: 10,
    //                 crossAxisCount: 3,
    //               ),
    //               itemCount: snapshot.data!.docs.length + 1,
    //               itemBuilder: (BuildContext context, int index) {
    //                 if (index == 0) {
    //                   print(widget.category);
    //                   return const SizedBox();
    //                   // return uploadProduct(category: categoryList[i]);
    //                 }
    //                 QueryDocumentSnapshot data =
    //                     snapshot.data!.docs[index - 1];
    //                 // var v = snapshot.data!.docs[index - 1]['priority'];

    //                 // String category = data['category'] ?? "";
    //                 String name = data['pro_name'] ?? "";
    //                 String price = data['pro_price'] ?? "";
    //                 // String userMail = data['user'] ?? "";
    //                 List urlImage = data['lis'] ?? [];
    //                 String shopName = data['nameShop'] ?? "";
    //                 String category = data['category'] ?? "";
    //                 String number = data['number'] ?? "";

    //                 print(data.data());
    //       //                 print("data");
    //       //                 return Column(children: [
    //       //                   CachedNetworkImage(
    //       //                     imageUrl: urlImage[0],
    //       //                     imageBuilder: (context, imageProvider) =>
    //       //                         GestureDetector(
    //       //                       onTap: () {
    //       //                         Navigator.push(
    //       //                           context,
    //       //                           MaterialPageRoute(
    //       //                             builder: (BuildContext context) =>
    //       //                                 ProductDetailScreen(
    //       //                               shopNumber: number,
    //       //                               city: widget.city,
    //       //                               subCity: widget.subCity,
    //       //                               name: name,
    //       //                               price: price,
    //       //                               category: widget.category,
    //       //                               // uploadProduct: uploadProduct(
    //       //                               //     category:
    //       //                               //         categoryList[i]),
    //       //                               urlImage: urlImage[0],
    //       //                               // category: category,
    //       //                               shopName: shopName,
    //       //                             ),
    //       //                           ),
    //       //                         );
    //       //                       },
    //       //                       child: Container(
    //       //                         height: 80,
    //       //                         alignment: Alignment.center,
    //       //                         decoration: BoxDecoration(
    //       //                           color: Colors.amber,
    //       //                           borderRadius:
    //       //                               BorderRadius.circular(15),
    //       //                           image: DecorationImage(
    //       //                             image: imageProvider,
    //       //                             fit: BoxFit.cover,
    //       //                           ),
    //       //                         ),
    //       //                       ),
    //       //                     ),
    //       //                     placeholder: (context, url) =>
    //       //                         CircularProgressIndicator(),
    //       //                     errorWidget: (context, url, error) =>
    //       //                         Icon(Icons.error),
    //       //                   ),
    //       //                   Center(child: Text(name)),
    //       //                 ]);
    //       //               },
    //       //             ),
    //       //             TextButton(
    //       //               onPressed: () {
    //       //                 Navigator.push(
    //       //                   context,
    //       //                   MaterialPageRoute(
    //       //                     builder: (BuildContext context) =>
    //       //                         UserSeeMoreDetailScreen(
    //       //                       category: widget.category,
    //       //                       city: widget.city,
    //       //                       subCity: widget.subCity,
    //       //                       bussinessNumber: widget.shopNumber,
    //       //                       // uploadProduct: uploadProduct(
    //       //                       //     category: widget.category),
    //       //                       shopName: widget.shopName,
    //       //                     ),
    //       //                   ),
    //       //                 );
    //       //               },
    //       //               child: Text("See more"),
    //       //             ),
    //       //           ],
    //       //         ),
    //       //       ),
    //       //     );
    //       //   },
    //       // )

    //     ],
    //   ),
    // ),

    // );
  }
}
