import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:near_mine/home/app_user/models/product_model.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/widgets/bottom/user_cart_screen/user_cart_screen.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/widgets/bottom/widgets/payment_widget.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/widgets/bottom/widgets/order_accept.dart';
import 'package:near_mine/test/list_inside_list/list_inside_list.dart';
import 'package:provider/provider.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../provider/provider_user.dart';

class BottomWidget extends StatefulWidget {
  BottomWidget({Key? key}) : super(key: key);

  @override
  State<BottomWidget> createState() => _BottomWidgetState();
}

class _BottomWidgetState extends State<BottomWidget> {
  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    // totalSingleBasket();

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: double.infinity,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              _isTapped
                  ? BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: Offset(0, 3),
                    )
                  : BoxShadow(
                      color: Colors.transparent,
                    )
            ],
          ),
          foregroundDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: Container(
            width: double.infinity,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              // border: Border.all(
              //   color: Colors.green,

              //   // color: Colors.grey.withOpacity(0.3),
              //   width: 2,
              // ),
              // borderRadius: BorderRadius.only(
              //     topRight: Radius.circular(40.0),
              //     bottomRight: Radius.circular(40.0),
              //     topLeft: Radius.circular(40.0),
              //     bottomLeft: Radius.circular(40.0)),
            ),
            foregroundDecoration: BoxDecoration(
              border: Border.all(
                color: Colors.white,

                // color: Colors.grey.withOpacity(0.3),
                width: 2,
              ),
            ),
            // color: Colors.black.withOpacity(0.4),

            child: InkResponse(
              splashColor: Colors.grey,
              highlightColor: Colors.transparent,
              onTap: () {
                setState(() {
                  _isTapped = true;
                });
                showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    // backgroundColor: Colors.green,
                    builder: (context) {
                      // totalSingleBasket();

                      var child;
                      return DraggableScrollableSheet(
                          expand: false,
                          initialChildSize: 0.40,
                          minChildSize: 0.26,
                          maxChildSize: 1,
                          builder: (context, scrollController) {
                            child ??= DefaultTabController(
                                length: 2,
                                child: UserCartScreen(
                                  scrollController: scrollController,
                                ));

                            return child;
                          });
                    }).whenComplete(() {
                  setState(() {
                    _isTapped = false;
                  });
                });
              },
              child: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Container(
                    // color: Colors.red,
                    decoration: BoxDecoration(
                        // color:Colors.red,

                        ),
                    // height: MediaQuery.of(context).size.height,
                    padding: EdgeInsets.only(right: 100),
                    height: 100,
                    child: SingleChildScrollView(
                      // controller: scrollController,
                      child: ListView.builder(
                        itemCount: context.watch<ProviderUser>().cart.length,
                        physics: const NeverScrollableScrollPhysics(),
                        // controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          // dd = 0.0;
                          var data =
                              Provider.of<ProviderUser>(context, listen: false)
                                      .cart
                                      .isNotEmpty
                                  ? Provider.of<ProviderUser>(context,
                                          listen: false)
                                      .cart[index]
                                  : [
                                      ProductModel(
                                          name: "test",
                                          number: "77777",
                                          shopName: "super",
                                          totalPrice: 0,
                                          image:
                                              "https://picsum.photos/250?image=9")
                                    ];

                          var to = 0.0;
                          var singleBasket = data.map((e) {
                            to += e.totalPrice;

                            return to;
                          });

                          var totalSingleBasket = singleBasket == null
                              ? [0.0]
                              : singleBasket.toList();

                          return Stack(
                            children: [
                              Column(
                                children: [
                                  // SizedBox(
                                  //   height: 10,
                                  // ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text("Cart",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 20)),
                                      Text(
                                        context
                                            .watch<ProviderUser>()
                                            .cart[index]
                                            .first
                                            .shopName
                                            .toUpperCase(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      Text(
                                        totalSingleBasket.last.toString(),
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ],
                                  ),

                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Container(
                                      width: double.infinity,
                                      height: 70,
                                      foregroundDecoration: BoxDecoration(
                                        color: context
                                                    .watch<ProviderUser>()
                                                    .cart[0][0]
                                                    .shopName ==
                                                "0000aaaabbbbcccc"
                                            ? Colors.white
                                            : null,
                                      ),
                                      padding: EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.black.withOpacity(0.1),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          // bottomRight: Radius.circular(40.0),
                                          topLeft: Radius.circular(4.0),
                                          // bottomLeft: Radius.circular(40.0)
                                        ),
                                      ),
                                      child: NotificationListener<
                                          ScrollNotification>(
                                        onNotification:
                                            (ScrollNotification notification) {
                                          if (notification
                                              is ScrollStartNotification) {
                                            context
                                                .read<ProviderUser>()
                                                .addSelectCartFalse(); // Handle your desired action on scroll start here.
                                          }
                                          return true;
                                          // Returning null (or false) to
                                          // "allow the notification to continue to be dispatched to further ancestors".
                                          // return null;
                                        },
                                        child: ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 2,
                                            );
                                          },
                                          reverse: false,
                                          // controller: _scrollController,
                                          primary: false,
                                          shrinkWrap: true,
                                          physics:
                                              const BouncingScrollPhysics(),
                                          // padding: const EdgeInsets.symmetric(
                                          //     horizontal: 10),
                                          itemCount: context
                                                  .watch<ProviderUser>()
                                                  .cart
                                                  .isNotEmpty
                                              ? context
                                                  .watch<ProviderUser>()
                                                  .cart[index]
                                                  .length
                                              : 0,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            var data = context
                                                .watch<ProviderUser>()
                                                .cart[index][i];
                                            final String image = data.image;
                                            final dynamic totalPrice =
                                                data.totalPrice;

                                            return Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                //  Text(
                                                //       "Cart",
                                                //       style: TextStyle(fontSize: 19),
                                                //     ),
                                                // SizedBox(height: 10),

                                                Container(
                                                  height: 30,
                                                  width: 30,
                                                  // foregroundDecoration:
                                                  //     BoxDecoration(
                                                  //   border: Border.all(
                                                  //     color: Colors.blue,
                                                  //     width: 0,
                                                  //   ),
                                                  // ),
                                                  child: Image.network(
                                                    image,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              AnimatedPositioned(
                                height:
                                    context.watch<ProviderUser>().cartSelected
                                        ? 32
                                        : 148,
                                width:
                                    context.watch<ProviderUser>().cartSelected
                                        ? 32
                                        : 108,
                                left: 8,
                                bottom:
                                    context.watch<ProviderUser>().cartSelected
                                        ? 32.0
                                        :  32.0,
                                duration: const Duration(milliseconds: 1000),
                                curve: Curves.easeInOut,
                                child: GestureDetector(
                                  onTap: () {},
                                  child: AnimatedRotation(
                                    turns:
                                        context.watch<ProviderUser>().cartTurns,
                                    curve: Curves.bounceIn,
                                    duration: Duration(
                                        milliseconds: context
                                                .watch<ProviderUser>()
                                                .cartSelected
                                            ? 500
                                            : 3000),
                                    child: context
                                                .watch<ProviderUser>()
                                                .cart[index][0]
                                                .shopName ==
                                            "0000aaaabbbbcccc"
                                        ? const SizedBox()
                                        : context
                                                .watch<ProviderUser>()
                                                .cartSelected
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                                child: Container(
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.amber,
                                                    // borderRadius:
                                                    //     BorderRadius.circular(15),
                                                    image: DecorationImage(
                                                      image: NetworkImage(context
                                                          .watch<ProviderUser>()
                                                          .cart[index][0]
                                                          .image),
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : null,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  const Positioned(
                    right: 40,
                    child: Icon(
                      Icons.arrow_drop_down_outlined,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SecoundRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // print("provder check");
    return Scaffold(
        body: ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Text(index.toString()),
                ],
              );
            }));
  }
}

class Second extends StatefulWidget {
  const Second(
      {Key? key,
      required this.shopName,
      required this.listss,
      required this.number})
      : super(key: key);
  final String shopName;
  final List listss;

  final String number;

  @override
  State<Second> createState() => _SecondState();
}

class _SecondState extends State<Second> {
  @override
  void dispose() {
    widget.number;
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  var value = 0.0;
  var total = 0.0;
  var shopName = "shopName";

  totalCalc(e) {
    value += e.totalPrice;
    total = value;
    shopName = e.shopName;
  }

  @override
  Widget build(BuildContext context) {
    value = 0.0;
    print("look number");

    return Scaffold(
        body: ListView.builder(
            itemCount: 1,
            itemBuilder: (context, index) {
              var y = context.watch<ProviderUser>().cart.isNotEmpty
                  ? context.watch<ProviderUser>().cart[index].length
                  : 0;
              // ignore: curly_braces_in_flow_control_structures
              print(widget.number);
              print("widget.number");

              // print(context.watch<ProviderUser>().cart[index][i].number);

              //   // ignore: curly_braces_in_flow_control_structures

              return Column(
                children: [
                  Column(
                      children: widget.listss.map((e) {
                    totalCalc(e);

                    print(value);
                    return Column(
                      children: [
                        Text(e.name.toString()),
                        Text(e.totalPrice.toString()),
                      ],
                    );
                  }).toList()),
                  Text(total.toString()),
                  Text(shopName.toString()),
                ],
              );
            }));
  }
}
