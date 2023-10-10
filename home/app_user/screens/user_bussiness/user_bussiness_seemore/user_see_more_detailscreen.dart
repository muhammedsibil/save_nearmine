import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/widgets/balance_appbar/screen_balance_appbar/balance_appbar.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/widgets/bottom/bottom_widget.dart';
import 'package:provider/provider.dart';

import '../../../../../constant/constant.dart';
import '../../../../../test/bottom_widget_test/bottom_widget.dart';
import '../../../provider/provider_user.dart';

enum Menu { productSelect, itemTwo, itemThree, itemFour }

class UserSeeMoreDetailScreen extends StatefulWidget {
  const UserSeeMoreDetailScreen(
      {Key? key,
      required this.city,
      required this.subCity,
      required this.category,
      this.uploadProduct,
      required this.bussinessNumber,
      required this.shopName})
      : super(key: key);
  final String bussinessNumber;
  final String city;
  final String subCity;
  final String category;
  final Widget? uploadProduct;
  final String shopName;

  @override
  State<UserSeeMoreDetailScreen> createState() =>
      _UserSeeMoreDetailScreenState();
}

class _UserSeeMoreDetailScreenState extends State<UserSeeMoreDetailScreen> {
  String _selectedMenu = "";

  cal() {
    String v = "hebbbb";
  }

  final ScrollController _controller = ScrollController();

  _scrollDown() {
    if (_controller.hasClients) {
      _controller.animateTo(_controller.position.minScrollExtent,
          duration: const Duration(seconds: 3), curve: Curves.ease);
    }
  }

  bool isScrollEnd = false;

  double posx = 100.0;
  double posy = 100.0;
  // void onTapDown(context, TapDownDetails details) {
  //   print('${details.globalPosition}');
  //   final Offset localOffset;
  //   final RenderBox getBox = context.findRenderObject();
  //   localOffset = getBox.globalToLocal(details.globalPosition);
  //   setState(() {
  //     posx = localOffset.dx;
  //     posy = localOffset.dy;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> product = context.watch<ProviderUser>().product;

    // print(context.watch<ProviderUser>().product[0]["name"]);
    bool isSelected = _selectedMenu == "productSelect";
    // print(_selectedMenu);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Text("welcome"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: Colors.white,
                          // foregroundColor: Colors.red,
                          automaticallyImplyLeading: false,
                          toolbarHeight: isSelected ? 200.0 : 0.0,
                          actions: [
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: BalancerAppBar(
                                product: product,
                                bal: cal,
                              ),
                            ),
                          ],
                        ),
                        body: SingleChildScrollView(
                          child: FutureBuilder<QuerySnapshot>(
                              future: FirebaseFirestore.instance
                                  .collection("Place")
                                  .doc(widget.city)
                                  .collection("SubCity")
                                  .doc(widget.subCity)
                                  .collection("Shop")
                                  .doc(widget.bussinessNumber)
                                  .collection("Category")
                                  .doc(widget.category)
                                  .collection("Product")
                                  .limit(19)
                                  .orderBy("time")
                                  .get(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<dynamic> snapshot) {
                                if (snapshot.data?.size == 0) {
                                  print("No collection");
                                  return widget.uploadProduct ??
                                      const SizedBox();
                                }
                                if (!snapshot.hasData) {
                                  return CircularProgressIndicator();
                                }

                                return ListTile(
                                  tileColor: Colors.blue.withOpacity(0.02),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 6, horizontal: 6),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isSelected)
                                        ListTile(
                                          leading: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  _selectedMenu = "";
                                                });
                                              },
                                              icon: Icon(Icons.close)),
                                          title: Text('Select items'),
                                        ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(widget.category.toUpperCase(),
                                              style: Constant.categoryHeading),
                                          PopupMenuButton<Menu>(
                                            // Callback that sets the selected popup menu item.
                                            onSelected: (Menu item) {
                                              setState(() {
                                                _selectedMenu = item.name;
                                              });
                                            },
                                            itemBuilder:
                                                (BuildContext context) =>
                                                    <PopupMenuEntry<Menu>>[
                                              const PopupMenuItem<Menu>(
                                                value: Menu.productSelect,
                                                child: Text('Select Items'),
                                              ),
                                              const PopupMenuItem<Menu>(
                                                value: Menu.itemTwo,
                                                child: Text('Item 2'),
                                              ),
                                              const PopupMenuItem<Menu>(
                                                value: Menu.itemThree,
                                                child: Text('Item 3'),
                                              ),
                                              const PopupMenuItem<Menu>(
                                                value: Menu.itemFour,
                                                child: Text('Item 4'),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  subtitle: Container(
                                    color: Colors.blue.withOpacity(0.03),
                                    padding: EdgeInsets.all(16),
                                    child: Column(children: [
                                      GridView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisSpacing: 1,
                                          crossAxisCount: 3,
                                        ),
                                        itemCount:
                                            snapshot.data!.docs.length + 1,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          if (index == 0) {
                                            return widget.uploadProduct ??
                                                const SizedBox();
                                          }
                                          QueryDocumentSnapshot data =
                                              snapshot.data!.docs[index - 1];
                                          // var v = snapshot.data!.docs[index - 1]['priority'];

                                          String category =
                                              data['category'] ?? "";
                                          String name = data['pro_name'] ?? "";
                                          String price =
                                              data['pro_price'] ?? "";
                                          String shopName =
                                              data['nameShop'] ?? "";
                                          String number = data['number'] ?? "";

                                          // String userMail = data['user'] ?? "";
                                          List urlImage = data['lis'] ?? [];
                                          String proWeightUnit =
                                              data['pro_weight_unit'] ?? "";
                                          var product = {
                                            "name": name,
                                            "image": urlImage[0],
                                            "proWeightUnit": proWeightUnit,
                                            "price": price,
                                            "shopName": shopName,
                                            "number": number,
                                          };

                                          bool isProductSelected = context
                                                  .read<ProviderUser>()
                                                  .productSelected[
                                              'isProductSelected'];
                                          int indexTap = context
                                              .read<ProviderUser>()
                                              .productSelected['index'];
                                          return InkWell(
                                            onTap: () {
                                              print("product.length");
                                              print(Provider.of<ProviderUser>(
                                                      context,
                                                      listen: false)
                                                  .product
                                                  .length);
                                              // print(product);

                                              context
                                                  .read<ProviderUser>()
                                                  .addToBalancerTwoFalse();

                                              cal();

                                              context
                                                  .read<ProviderUser>()
                                                  .addWeight(product);
                                              Map productSelected = {
                                                'index': index,
                                                'isProductSelected': true,
                                              };
                                              context
                                                  .read<ProviderUser>()
                                                  .addProductSelected(
                                                      productSelected);
                                              Future.delayed(
                                                  const Duration(
                                                      milliseconds: 10), () {
                                                Map productSelectedFalse = {
                                                  'index': index,
                                                  'isProductSelected': false,
                                                };
                                                context
                                                    .read<ProviderUser>()
                                                    .addProductSelected(
                                                        productSelectedFalse);
                                              });
                                              context
                                                  .read<ProviderUser>()
                                                  .addSelectCartFalse();
                                              setState(() {
                                                // x = 10.0;
                                                // y = 11.0;
                                              });
                                            },
                                            child: Column(children: [
                                              Stack(
                                                // alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    height: isProductSelected
                                                        ? indexTap == index
                                                            ? 80
                                                            : 80
                                                        : 80,
                                                    width: isProductSelected
                                                        ? indexTap == index
                                                            ? double.infinity
                                                            : null
                                                        : null,
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      border: isProductSelected
                                                          ? indexTap == index
                                                              ? Border.all(
                                                                  color: Colors
                                                                      .blue
                                                                      .shade100,
                                                                  width: 10,
                                                                )
                                                              : null
                                                          : null,
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        image: NetworkImage(
                                                            urlImage[0]),
                                                        fit: isProductSelected
                                                            ? indexTap == index
                                                                ? BoxFit.fill
                                                                : BoxFit.cover
                                                            : BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  if (_selectedMenu ==
                                                      "productSelect")
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: RawMaterialButton(
                                                        constraints:
                                                            const BoxConstraints(
                                                                minWidth: 24,
                                                                minHeight: 24),
                                                        materialTapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        padding:
                                                            const EdgeInsets
                                                                .all(6.0),
                                                        onPressed: () {},
                                                        elevation: 2.0,
                                                        fillColor: Colors.white,
                                                        child: const Icon(
                                                          Icons
                                                              .add_shopping_cart_outlined,
                                                          size: 14.0,
                                                        ),
                                                        // padding: EdgeInsets.all(0.0),
                                                        shape:
                                                            const CircleBorder(),
                                                      ),
                                                    ),
                                                  Positioned.fill(
                                                    child: Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal: 6,
                                                                vertical: 6),
                                                        margin:
                                                            EdgeInsets.all(4),
                                                        child: Text(
                                                          price,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Center(
                                                  child: Column(
                                                children: [
                                                  Text(name),
                                                ],
                                              )),
                                            ]),
                                          );
                                        },
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            // Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(
                                            //         builder:
                                            //             (BuildContext context) =>
                                            //                   MyStatelessWidget()));
                                          },
                                          child: const Text("See more")),
                                    ]),
                                  ),
                                );
                              }),
                        ),
                      ),
                    ),
                  ],
                ),

                AnimatedPositioned(
                  right: 300 - posx,
                  bottom: posy,
                  child: Container(
                    color: Colors.red,
                    height: 30,
                    width: 30,
                  ),
                  duration: const Duration(seconds: 3),
                ),
                // Container(
                //   height: 90,
                //   width: 90,
                //   color: Colors.green,
                //   child: GestureDetector(
                //     onTapDown: (TapDownDetails details) =>
                //         onTapDown(context, details),
                //   ),
                // ),
              ],
            ),
          ),
          bottomSheet: BottomWidget()),
    );
  }
}
