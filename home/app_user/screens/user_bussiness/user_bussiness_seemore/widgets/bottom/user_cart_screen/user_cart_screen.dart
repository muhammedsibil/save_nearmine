import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/product_model.dart';
import '../../../../../../provider/provider_user.dart';
import '../widgets/congrats_alert_order.dart';
import '../widgets/order_accept.dart';
import '../widgets/payment_widget.dart';

enum _Tab { one, two }

class UserCartScreen extends StatefulWidget {
  const UserCartScreen({super.key, this.scrollController});
  final ScrollController? scrollController;

  @override
  State<UserCartScreen> createState() => _UserCartScreenState();
}

class _UserCartScreenState extends State<UserCartScreen> {
  double sum = 0.0;
// int sum = value.toInt();

  var aduSho = "ss";
  var shopName = "helo";
  var number = "nn";

  List li = [];
  _Tab _selectedTab = _Tab.one;
  var isUpiActive = false;
  bool isCancelOrder = false;
  bool isOrderSccess = false;

  late String cartDetailsShopName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Text("Recent Cart")),
              Tab(icon: Text("Orderd")),
            ],
          ),
          title: const Text('Cart'),
        ),
        body: TabBarView(
          children: [
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return Container(
                  color: Colors.blue.withOpacity(0.1),
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    controller: widget.scrollController,
                    child: ListView.builder(
                        // reverse: true,
                        itemCount:
                            context.watch<ProviderUser>().cart.length + 1,
                        physics: const NeverScrollableScrollPhysics(),
                        // controller: scrollController,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          if (index == 0) {
                            var orderdSuccess = Provider.of<ProviderUser>(
                                    context,
                                    listen: false)
                                .orderdSuccess;
                            var shopName = orderdSuccess["shopName"]??"";
                            var shopNumber = orderdSuccess["price"] ??"";

                            return CongratsAlertOrder(
                                shopNumber: shopNumber, shopName: shopName);
                          }
                          // dd = 0.0;
                          var data =
                              Provider.of<ProviderUser>(context, listen: false)
                                      .cart
                                      .isNotEmpty
                                  ? Provider.of<ProviderUser>(context,
                                          listen: false)
                                      .cart[index - 1]
                                  : [
                                      ProductModel(
                                          name: "test",
                                          number: "77777",
                                          shopName: "test",
                                          totalPrice: 0,
                                          image: "")
                                    ];

                          var to = 0.0;
                          var singleBasket = data.map((e) {
                            to += e.totalPrice;

                            return to;
                          });

                          var totalSingleBasket = singleBasket == null
                              ? [0.0]
                              : singleBasket.toList();
                          cartDetailsShopName = data.first.shopName;

                          return data.first.totalPrice == 0.0
                              ? Container(
                                  color: Colors.red,
                                  // width: scrollController.position.
                                  //     .toDouble(),
                                  height: 100,
                                  alignment: Alignment.center,
                                  child: Text("Cart empty"))
                              : Container(
                                  margin: EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  color: Colors.white,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: ListTile(
                                          //  dense: true,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 0.0, vertical: 0.0),
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              // Text(aduSho),
                                              Text(cartDetailsShopName
                                                  .toString()),
                                              Text(
                                                totalSingleBasket.last
                                                    .toString(),
                                                style: TextStyle(fontSize: 10),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      context.read<ProviderUser>().cart.isEmpty
                                          ? const SizedBox()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  color: Colors.black,
                                                  height: 6,
                                                  width: 4,
                                                ),
                                                context
                                                            .read<
                                                                ProviderUser>()
                                                            .cart[index - 1]
                                                            .length <
                                                        2
                                                    ? const SizedBox(
                                                        width: 24,
                                                      )
                                                    : const SizedBox(
                                                        width: 50,
                                                      ),
                                                // SizedBox(width: 30,),

                                                Container(
                                                  color: Colors.black,
                                                  height: 6,
                                                  width: 4,
                                                ),
                                              ],
                                            ),
                                      Container(
                                        height: 130,
                                        width: double.infinity,
                                        child: ListView.separated(
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return SizedBox(
                                              width: 6,
                                            );
                                          },
                                          reverse: false,
                                          // controller: _scrollController,
                                          primary: false,
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          itemCount: context
                                                  .watch<ProviderUser>()
                                                  .cart
                                                  .isNotEmpty
                                              ? context
                                                  .watch<ProviderUser>()
                                                  .cart[index - 1]
                                                  .length
                                              : 0,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, i) {
                                            var to = context
                                                .watch<ProviderUser>()
                                                .cart[index - 1][i]
                                                .totalPrice;
                                            var data = context
                                                .watch<ProviderUser>()
                                                .cart[index - 1][i];

                                            // var weightRecentCart =
                                            //     context
                                            //         .watch<
                                            //             ProviderUser>()
                                            //         .cart[
                                            //             index]
                                            //             [i]
                                            //         .weight;

                                            return GestureDetector(
                                              onTap: () {
                                                // context
                                                //     .read<ProviderUser>()
                                                //     .deleteCartItem(
                                                //       context
                                                //           .read<ProviderUser>()
                                                //           .cart[index][i]
                                                //           .shopName,
                                                //     );
                                                context
                                                    .read<ProviderUser>()
                                                    .deleteCartItem(data: data);
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Stack(
                                                    // alignment: Alignment.topRight,
                                                    children: [
                                                      Container(
                                                        height: 70,
                                                        width: 70,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.blue
                                                              .withOpacity(
                                                                  0.150),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          20)),
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(6),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          child:
                                                              SizedBox.fromSize(
                                                            size:
                                                                Size.fromRadius(
                                                                    48),
                                                            child:
                                                                Image.network(
                                                              data.image,
                                                              fit: BoxFit.cover,
                                                              // color: Colors.red,
                                                              // height:
                                                              //     30,
                                                              // width:
                                                              //     30,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    " ${data.name.toString()}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  Text(
                                                    "RS: ${to.toString()}",
                                                    style: const TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                  (data.itemCount == 0)
                                                      ? Text(
                                                          "${data.weight.toString()}${data.weightUnit.toString()}",
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                        )
                                                      : Text(
                                                          "Item: ${data.itemCount.toString()}",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30.0),
                                        child: Row(
                                          children: [
                                            Text(
                                              "MRP: ",
                                              style: TextStyle(
                                                fontSize: 24,
                                              ),
                                            ),
                                            Text(
                                              totalSingleBasket.last.toString(),
                                              style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          var numberShop =
                                              Provider.of<ProviderUser>(context,
                                                      listen: false)
                                                  .cart[index - 1][0]
                                                  .number;
                                        },
                                        child: PaymentWidget(
                                          index: index - 1,

                                          isUpiActive: isUpiActive,
                                          datas: data,
                                          // products: products,
                                          totalSingleBasket:
                                              totalSingleBasket.last.toString(),
                                        ),
                                      )
                                    ],
                                  ),
                                );
                        }),
                  ),
                );
              },
            ),
            OrderAccept(scrollController: widget.scrollController),
          ],
        ),
      ),
    );
  }
}
