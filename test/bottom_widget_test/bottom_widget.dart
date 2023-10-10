import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../home/app_user/provider/provider_user.dart';

class BottomWidgetTest extends StatefulWidget {
  BottomWidgetTest({Key? key}) : super(key: key);

  @override
  State<BottomWidgetTest> createState() => _BottomWidgetTestState();
}

class _BottomWidgetTestState extends State<BottomWidgetTest> {
  // double sum = 0.0;

  List li = [];
  // var dd = 0.0;
  // var vv = 0.0;
  // var te = 0.0;
  var shopName = "oo";
  var number = "num";
  // var gg = 0.40;
  // ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // _scrollDown();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.animateTo(
    //       _scrollController.position.maxScrollExtent,
    //       curve: Curves.easeOut,
    //       duration: const Duration(milliseconds: 500),
    //     );
    //   }
    // });
  }

  var aduSho = "ss";
  // test({totalPrice}) {
  //   dd += totalPrice;

  //   vv = dd;
  // }

// This is what you're looking for!
  // void _scrollDown() {
  //   if (_controller.hasClients) {

  //       _controller.animateTo(
  //         _controller.position.maxScrollExtent,
  //         duration: Duration(seconds: 1),
  //         curve: Curves.fastOutSlowIn,
  //       );

  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // dd = 0.0;

    return Scaffold(
      appBar: AppBar(
        // title: Text(context.watch()<ProviderUser>().shopTotalBill.toString()),
        actions: [
          for (var i = 0; i < context.watch<ProviderUser>().cart.length; i++)
            Container(
              padding: EdgeInsets.all(10),
              child:
                  Column(children: li.map((e) => Text(e.toString())).toList()),
            ),
        ],
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Container(
              height: 600,
              child: ListView.builder(
                  reverse: true,
                  itemCount: context.watch<ProviderUser>().cart.length,
                  physics: const NeverScrollableScrollPhysics(),
                  // controller: scrollController,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    li.clear();
                    // dd = 0.0;
                    var data = Provider.of<ProviderUser>(context, listen: false)
                            .cart
                            .isNotEmpty
                        ? Provider.of<ProviderUser>(context, listen: false)
                            .cart[index]
                        : [];
                    var to = 0.0;
                    var ch = data.map((e) {
                      to += e.totalPrice;

                      return to;
                    });

                    var f = ch == null ? [0.0] : ch.toList();
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.white,
                      child: Column(
                        children: [
                          Text(f.last.toString()),
                          Align(
                            alignment: Alignment.topLeft,
                            child: ListTile(
                              //  dense: true,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 0.0, vertical: 0.0),
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text(aduSho),
                                  Text(shopName),
                                  Text(number, style: TextStyle(fontSize: 10)),
                                ],
                              ),
                            ),
                          ),
                          context.read<ProviderUser>().cart.isEmpty
                              ? const SizedBox()
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      color: Colors.black,
                                      height: 6,
                                      width: 4,
                                    ),
                                    context
                                                .read<ProviderUser>()
                                                .cart[index]
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
                            height: 90,
                            width: 199,
                            child: ListView.builder(
                              // physics: NeverScrollableScrollPhysics(),
                              reverse: false,
                              // controller: _scrollController,
                              primary: false,
                              shrinkWrap: true,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              itemCount:
                                  context.watch<ProviderUser>().cart.isNotEmpty
                                      ? context
                                          .watch<ProviderUser>()
                                          .cart[index]
                                          .length
                                      : 0,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, i) {
                                var to = context
                                    .watch<ProviderUser>()
                                    .cart[index][i]
                                    .totalPrice;

                                // dd = dd + totalPrice;

                                return Stack(
                                  // alignment: Alignment.topRight,
                                  children: [
                                    ColorFiltered(
                                      colorFilter: ColorFilter.mode(
                                          Colors.black.withOpacity(0.5),
                                          BlendMode.colorBurn),
                                      child: Column(
                                        children: [
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {
                                              context
                                                  .read<ProviderUser>()
                                                  .deleteCartItem(
                                                 number:    context
                                                        .read<ProviderUser>()
                                                        .cart[index][i]
                                                        .number,
                                                  );
                                            },
                                            icon: Image.network(
                                              context
                                                  .watch<ProviderUser>()
                                                  .cart[index][i]
                                                  .image,
                                              fit: BoxFit.cover,
                                              height: 40,
                                              width: 60,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      // top: 10,
                                      bottom: 10,
                                      child: Text(to.toString(),
                                          style: TextStyle(color: Colors.red)),
                                    )
                                  ],
                                );
                              },
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // _scrollDown();
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) => SecoundRoute()),
                              // );
                            },
                            child: Text("dd.toString()"),
                          ),
                        ],
                      ),
                    );

                    // return   Text(context.watch<ProviderUser>().cart[index][i].name.toString())
                  }),
            ),
          )),
      bottomNavigationBar: const Text("Close"),
    );
  }
}

class SecoundRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text("jjjj"));
  }
}
