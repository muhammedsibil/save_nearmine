import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../../../../../../../../find_city/provider/data.dart';
import '../../../../../../models/product_model.dart';
import '../../../../../../provider/provider_user.dart';

enum Payment { UPI, CASHONDELIVERY, TAKEAWAY }

class PaymentWidget extends StatefulWidget {
  const PaymentWidget(
      {Key? key,
      this.isUpiActive = false,
      required this.datas,
      // required this.productModel,
      this.index = 0,
      this.totalSingleBasket,
      this.products})
      : super(key: key);
  final int index;

  final bool isUpiActive;
  final List<ProductModel> datas;
  final List<Map>? products;
  // final ProductModel productModel;
  final String? totalSingleBasket;
  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final orderInstance = FirebaseFirestore.instance;

  // final Fruit? _payMode = null;
  Payment? _payMode;
  bool isUpiActive = false;
  bool isOrderSccess = false;
  var isPhonepeInstalled;
  var isGpayInstalled;

  var pdata;
  @override
  void initState() {
    super.initState();
    isInstalledApps();
    _data = widget.datas;
  }

  isInstalledApps() async {
    isPhonepeInstalled = await LaunchApp.isAppInstalled(
      androidPackageName: 'com.phonepe.app',
    );

    isGpayInstalled = await LaunchApp.isAppInstalled(
      androidPackageName: 'com.google.android.apps.nbu.paisa.user',
    );
  }

  bool _value = true;
  bool isUpiTransaction = false;
  bool isCustomerUpiTransactionStatus = false;

  String city = "manjeri";
  String subCity = "elankur";
  String numberShop = "9995498550";
  String nameShop = "name shop";

  List<ProductModel> _data = [];
  List<Map> data = [];

  List<Map> toData() {
    setState(() {
      _data.forEach((item) {
        Map v = {
          "name": item.name,
          "image": item.image,
          "totalPrice": item.totalPrice,
          "shopName": item.shopName,
          "number": item.number,
          "weight": item.weight,
          "weightUnit": item.weightUnit,
          "itemCount": item.itemCount,
        };

        data.add(v);
      });
    });
    return data.toList();
  }

  @override
  Widget build(BuildContext context) {
    city = context.watch<CityModel>().city;
    subCity = context.watch<CityModel>().subCity;
    // numberShop = context.watch<CityModel>().numberShop;
    nameShop = context.watch<CityModel>().nameShop;

    return isCustomerUpiTransactionStatus
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "Seller Payment Response: success / fail / not Checked",
                style: TextStyle(
                  color: Colors.black,
                  // fontWeight: FontWeight.bold,
                  // fontSize: 16,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Order Placed, thank you!",
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                ),
              ),
            ],
          )
        : isUpiTransaction
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text("payment is success ?"),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isOrderSccess = true;
                          isCustomerUpiTransactionStatus = true;
                        });
                      },
                      child: Text("Yes")),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          isUpiTransaction = false;
                        });
                      },
                      child: Text("No")),
                ],
              )
            : Column(children: [
                Container(
                  color: _payMode == Payment.TAKEAWAY
                      ? Colors.purple.withOpacity(0.2)
                      : null,
                  child: ListTile(
                    title: const Text('Takeaway'),
                    leading: Radio<Payment>(
                      value: Payment.TAKEAWAY,
                      groupValue: _payMode,
                      onChanged: (Payment? value) {
                        setState(() {
                          _payMode = value;
                          isUpiActive = widget.isUpiActive;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  color: _payMode == Payment.CASHONDELIVERY
                      ? Colors.purple.withOpacity(0.2)
                      : null,
                  child: ListTile(
                    title: const Text('Cash on Delivery'),
                    leading: Radio<Payment>(
                      value: Payment.CASHONDELIVERY,
                      groupValue: _payMode,
                      onChanged: (Payment? value) {
                        setState(() {
                          _payMode = value;
                          isUpiActive = widget.isUpiActive;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  color: _payMode == Payment.UPI
                      ? Colors.purple.withOpacity(0.2)
                      : null,
                  child: ListTile(
                    title: const Text('UPI'),
                    leading: Radio<Payment>(
                      value: Payment.UPI,
                      groupValue: _payMode,
                      onChanged: (Payment? value) {
                        setState(() {
                          _payMode = value;
                          isUpiActive = true;
                        });
                      },
                    ),
                    subtitle: isUpiActive
                        ? ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Text("To,"),
                                Text("UPI ID    :    sibii@16"),
                                Text("Phone number   :   9061615995"),
                                SizedBox(
                                  height: 16,
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (isPhonepeInstalled) {
                                      await LaunchApp.openApp(
                                        androidPackageName: 'com.phonepe.app',
                                      );
                                      setState(() {
                                        isUpiTransaction = true;
                                      });
                                    }
                                    await LaunchApp.isAppInstalled(
                                      androidPackageName: 'com.phonepe.app',
                                    );
                                    setState(() {
                                      isUpiTransaction = true;
                                    });
                                  },
                                  child: Container(
                                    child: const Center(
                                      child: Text(
                                        "Phonepe",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (isGpayInstalled) {
                                      await LaunchApp.openApp(
                                        androidPackageName:
                                            'com.google.android.apps.nbu.paisa.user',
                                      );
                                      setState(() {
                                        isUpiTransaction = true;
                                      });
                                    }
                                    await LaunchApp.isAppInstalled(
                                      androidPackageName:
                                          'com.google.android.apps.nbu.paisa.user',
                                    );
                                    setState(() {
                                      isUpiTransaction = true;
                                    });
                                  },
                                  child: Container(
                                    child: Center(
                                      child: Text(
                                        "Gpay",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ),
                ),
                _payMode == Payment.UPI
                    ? const SizedBox()
                    : _payMode == Payment.CASHONDELIVERY
                        ? SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ButtonStyle(

                                    // backgroundColor: Colors.purple.withOpacity(0.2)
                                    ),
                                onPressed: () {
                                  context
                                      .read<ProviderUser>()
                                      .addOrderedSuccess(
                                          shopName: context
                                              .read<ProviderUser>()
                                              .cart[widget.index][0]
                                              .shopName,
                                          price: widget.totalSingleBasket
                                              .toString());

                                  context.read<ProviderUser>().deleteCartItem(
                                        number: context
                                            .read<ProviderUser>()
                                            .cart[widget.index][0]
                                            .number,
                                      );
                                  _showMyDialog();
                                  orderPlacedWidget();
                                },
                                child: Text("Continue")),
                          )
                        : _payMode == Payment.TAKEAWAY
                            ? SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ButtonStyle(

                                        // backgroundColor: Colors.purple.withOpacity(0.2)
                                        ),
                                    onPressed: () {
                                      context
                                          .read<ProviderUser>()
                                          .addOrderedSuccess(
                                              shopName: context
                                                  .read<ProviderUser>()
                                                  .cart[widget.index][0]
                                                  .shopName,
                                              price: widget.totalSingleBasket
                                                  .toString());

                                      context
                                          .read<ProviderUser>()
                                          .deleteCartItem(
                                            number: context
                                                .read<ProviderUser>()
                                                .cart[widget.index][0]
                                                .number,
                                          );

                                      _showMyDialog();
                                      orderPlacedWidget();
                                    },
                                    child: Text("Continue")),
                              )
                            : const SizedBox()
              ]);
  }

  orderPlacedWidget() {
    List<Map<String, dynamic>> productList =
        widget.datas.map((product) => product.toJson()).toList();
    Timer(Duration(seconds: 0), () {
      print("Yeah, this line is printed after 3 seconds");
      if (widget.datas.isNotEmpty) {
        print("conti");
        print(widget.datas);

        var order = orderInstance
            .collection("Place")
            .doc(city.toLowerCase())
            .collection("SubCity")
            .doc(subCity.toLowerCase())
            .collection("Shop")
            .doc(widget.datas.first.number.toString())
            .collection("Order")
            .doc();
        order.set({
          // "user": loginUser!.email.toString(),
          "time": DateTime.now(),
          "docId": order.id,
          "userName": "abu",
          "userNumber": "456791",
          "order": productList,
          "orderRequist": "not_accept",
          // "order": widget.data.toList(),
          "nameShop": widget.datas.first.shopName.toString(),
          "numberShop": widget.datas.first.number.toString(),
        });
      }
    });

    setState(() {
      _payMode = null;
      isUpiActive = false;
      isOrderSccess = true;
      print("dc");
      // var stringList = getFriendList().split(",");
    });
  }

  Future<void> _showMyDialog() {
    return showDialog<void>(
      context: context,
      // barrierDismissible:
      //      ? false : true, // user must tap button!
      builder: (BuildContext context) {
        return CircularLoadWidget();
      },
    );
  }
}

final key = GlobalKey<_CircularLoadWidgetState>();

class CircularLoadWidget extends StatefulWidget {
  const CircularLoadWidget({super.key});

  @override
  State<CircularLoadWidget> createState() => _CircularLoadWidgetState();
}

class _CircularLoadWidgetState extends State<CircularLoadWidget> {
  bool _isLoad = true;
  bool get isLoad => _isLoad;

  callme() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _isLoad = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    callme();
  }

  @override
  Widget build(BuildContext context) {
    return isLoad
        ? AlertDialog(
            content: Container(
              // color: Colors.red,
              height: 100,
              width: 100,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          )
        : AlertDialog(
            // title: const Text("Order Placed, thank you!"),
            content: Container(
              //  color: Colors.red,
              height: 100,
              width: 100,
              child: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("Order Placed, thank you!"),
                    Text(
                      context
                          .watch<ProviderUser>()
                          .orderdSuccess['shopName']
                          .toString(),
                    ),
                    Text(
                      context
                          .watch<ProviderUser>()
                          .orderdSuccess['price']
                          .toString(),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: const Text('Ok'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
