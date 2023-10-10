import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../provider/provider_user.dart';
import 'add_cart_button.dart';
import 'select_count_weight.dart';

class SelectWeightMachine extends StatefulWidget {
  const SelectWeightMachine(
      {super.key,
      this.totalPrice,
      this.price,
      this.proTotalWeight,
      this.selectedProductbuy,
      this.product,
      this.totalValue,
      this.weight,
      this.weightUnit,
      this.yes});
  final dynamic totalPrice;
  final dynamic price;
  final dynamic proTotalWeight;
  final dynamic yes;
  final dynamic selectedProductbuy;
  final dynamic product;
  final dynamic weightUnit;
  final dynamic weight;
  final dynamic totalValue;
  @override
  State<SelectWeightMachine> createState() => _SelectWeightMachineState();
}

class _SelectWeightMachineState extends State<SelectWeightMachine> {
  final ScrollController _controller = ScrollController();

  _scrollDown() {
    _controller.animateTo(_controller.position.maxScrollExtent + 400,
        duration: const Duration(seconds: 3), curve: Curves.ease);
  }

  int animationDelay = 3000;
  @override
  Widget build(BuildContext context) {
    var totalPrice = widget.totalPrice;
    var price = widget.price;
    var proTotalWeight = widget.proTotalWeight;
    var yes = widget.yes;
    var selectedProductbuy = widget.selectedProductbuy;
    var product = widget.product;
    var image = widget.product.last['image'];
    var weightUnit = widget.weightUnit;
    var weight = widget.weight;
    var totalValue = widget.totalValue;
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          color: Colors.grey,
          height: 190,
          width: 10,
        ),
        //cartbutton+machine
        Container(
          color: Colors.grey.withOpacity(0.3),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  color: Colors.white,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          totalPrice == 0
                              ? price.toString()
                              : "${totalPrice.toStringAsFixed(0)} RS",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                        Flexible(
                          child: Text(
                            "${proTotalWeight.toStringAsFixed(yes ? 0 : proTotalWeight % 1 == 0 ? 1 : 3)} $weightUnit",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ),
                        SizedBox(
                          width: 4,
                        ),
                      ]),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  //weightmachine

                  selectedProductbuy
                      ? Text("sss")
                      : Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // if (product.isNotEmpty)

                                Container(
                                  width: 190,
                                  height: 150,
                                  child: Stack(
                                    children: <Widget>[
                                      AnimatedPositioned(
                                        height: 20,
                                        width: 180,
                                        // top: 160.0,
                                        bottom: 0.0,

                                        duration: Duration(
                                            milliseconds: animationDelay),
                                        curve: Curves.fastOutSlowIn,
                                        child: AnimatedRotation(
                                          turns: context
                                              .watch<ProviderUser>()
                                              .turns,
                                          curve: Curves.fastOutSlowIn,
                                          duration: Duration(
                                              milliseconds: animationDelay),
                                          child: Container(
                                            alignment: Alignment.topCenter,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade400,
                                                borderRadius: BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(6))),
                                            child: Divider(
                                              color: Colors.blueGrey,
                                              height: 9,
                                            ),
                                            // height: 6,
                                            // width: 140,
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        height: context
                                                .watch<ProviderUser>()
                                                .selected
                                            ? 130
                                            : 79,
                                        width: context
                                                .watch<ProviderUser>()
                                                .selected
                                            ? 100
                                            : 79,
                                        // top: selected ? 26.0 : 40.0,
                                        // top: context.watch<ProviderUser>().selected
                                        //     ? 1.0
                                        //     : 4.0,
                                        // right: 10,
                                        left: 16,
                                        bottom: context
                                                .watch<ProviderUser>()
                                                .selected
                                            ? 60
                                            : 26.0,

                                        duration: Duration(milliseconds: 1000),
                                        curve: Curves.linear,
                                        child: GestureDetector(
                                          onTap: () {
                                            // bool selected = false;

                                            context
                                                .read<ProviderUser>()
                                                .addSelect();
                                            // setState(() {
                                            //   _changeRotation();
                                            //   selected = !selected;
                                            // });
                                          },
                                          child: AnimatedRotation(
                                            turns: context
                                                .watch<ProviderUser>()
                                                .turns,
                                            curve: Curves.bounceIn,
                                            duration: Duration(
                                                milliseconds: animationDelay),
                                            child: (widget.product.length == 1)
                                                ? const SizedBox()
                                                : Container(
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.amber,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      image: DecorationImage(
                                                        image:
                                                            NetworkImage(image),
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () {
                                                        if (widget.product
                                                                .length >
                                                            1)
                                                          context
                                                              .read<
                                                                  ProviderUser>()
                                                              .removeProduct(
                                                                  product.last[
                                                                      'name']);
                                                      },
                                                      icon: Icon(Icons.close),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        height: 100,
                                        width: 60,
                                        right: 10,
                                        bottom: context
                                                .watch<ProviderUser>()
                                                .selected
                                            ? 15.0
                                            : 20.0,
                                        duration: Duration(milliseconds: 1000),
                                        curve: Curves.easeInOut,
                                        child: InkWell(
                                          onTap: () {
                                            context
                                                .read<ProviderUser>()
                                                .addSelect();
                                          },
                                          child: AnimatedRotation(
                                            turns: 1,
                                            curve: Curves.bounceIn,
                                            duration: Duration(
                                                milliseconds: animationDelay),
                                            child: ListView.builder(
                                              reverse: true,
                                              controller: _controller,
                                              // itemCount: context
                                              //     .read<ProviderUser>()
                                              //     .weightKatta
                                              //     .length,
                                              itemCount: context
                                                  .watch<ProviderUser>()
                                                  .testKatta
                                                  .length,
                                              itemBuilder: (context, index) {
                                                // return InkWell(
                                                //   onTap: () {
                                                //     context
                                                //         .read<ProviderUser>()
                                                //         .weightKatta
                                                //         .clear();

                                                //     context
                                                //         .read<ProviderUser>()
                                                //         .deleteTotalWeight();
                                                //   },
                                                //   child: context
                                                //       .read<ProviderUser>()
                                                //       .weightKatta[index],
                                                // );
                                                var data = context
                                                    .watch<ProviderUser>()
                                                    .testKatta[index];
                                                return InkWell(
                                                  onTap: () {
                                                    context
                                                        .read<ProviderUser>()
                                                        .removeTestKattaTotalDup(
                                                            index,
                                                            data[
                                                                "weightConverted"],
                                                            context);
                                                    context
                                                        .read<ProviderUser>()
                                                        .testKattaRemove(index);
                                                    // context
                                                    //     .read<ProviderUser>()
                                                    //     .testKattaRemove(index);
                                                    // context
                                                    //     .read<ProviderUser>()
                                                    //     .weightKatta
                                                    //     .clear();

                                                    // context
                                                    //     .read<ProviderUser>()
                                                    //     .deleteTotalWeight();
                                                  },
                                                  child: Container(
                                                    height:
                                                        data["heightOfWeight"],
                                                    margin: EdgeInsets.all(1),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: Colors.black,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                    width: 30,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(data[
                                                                "weightConverted"]
                                                            .toStringAsFixed(
                                                                0)),
                                                        Text(data["measure"]
                                                            .toString()),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      AnimatedPositioned(
                                        bottom: 20,
                                        left: 10,
                                        child: Container(
                                          height: 16,
                                          width: 90,
                                          decoration: BoxDecoration(
                                            color: Colors.green,
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(15),
                                              bottomRight: Radius.circular(20),
                                            ),
                                          ),
                                        ),
                                        duration: Duration(
                                            milliseconds: animationDelay),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              // color: Colors.black45,
                              height: 150,
                              width: 50,
                              child: ListView.builder(
                                itemCount: weight.length,
                                itemBuilder: (context, index) {
                                  var weightInGram = weight[index]['weight'];
                                  late var weightConverted;
                                  // var v = weightConverted?.toStringAsFixed(0);
                                  var measure;
                                  if (weightInGram < 1) {
                                    weightConverted = weightInGram * 1000;
                                    measure = "G";
                                    // return gram;
                                  } else if (weightInGram >= 1) {
                                    weightConverted = weightInGram;
                                    measure = "KG";
                                    // return gram;
                                  }

                                  return InkWell(
                                    onTap: () {
                                      var weightOfProduct =
                                          weight[index]['weight'];
                                      var heightOfWeight =
                                          weight[index]['hieght'] * 10;
                                      Map<String, dynamic> tes = {
                                        "weightOfProduct": weightOfProduct,
                                        "weightConverted": weightConverted,
                                        "measure": measure,
                                        "heightOfWeight": heightOfWeight,
                                      };
                                      print("tes");
                                      print(tes);
                                      context
                                          .read<ProviderUser>()
                                          .testKattaMethod(tes);
                                      context
                                          .read<ProviderUser>()
                                          .addToBalancer();
                                      context
                                          .read<ProviderUser>()
                                          .addTestKattaTotalDup(
                                              weightConverted, context);

                                      // context
                                      //     .read<ProviderUser>()
                                      //     .addTotalWeight(weightOfProduct);

                                      // context.read<ProviderUser>().addWeightKatta(
                                      //       Container(
                                      //         margin: EdgeInsets.all(1),
                                      //         alignment: Alignment.center,
                                      //         decoration: BoxDecoration(
                                      //           color: Colors.black,
                                      //           borderRadius:
                                      //               BorderRadius.circular(4),
                                      //         ),
                                      //         height: weight[index]['hieght'] * 10,
                                      //         width: 60,
                                      //         child: Column(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment.center,
                                      //           children: [
                                      //             Text(weightConverted
                                      //                 .toStringAsFixed(0)),
                                      //             Text(measure.toString()),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     );

                                      if (_controller.hasClients) {
                                        _scrollDown();
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: widget.product.length == 1
                                            ? Colors.black87.withOpacity(0.8)
                                            : Colors.black87.withOpacity(0.8),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      margin: const EdgeInsets.only(
                                          bottom: 1, left: 4),
                                      // padding: EdgeInsets.all(4),

                                      alignment: Alignment.center,
                                      // color: Colors.yellow,
                                      height: weight[index]['hieght'] * 10,
                                      width: 60,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(weightConverted
                                              .toStringAsFixed(0)),
                                          Text(measure.toString())
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),

                  //addtocart
                  AddtoCartButton(
                      product: product,
                      totalValue: totalValue,
                      proTotalWeight: proTotalWeight,
                      weightUnit: weightUnit,
                      height: 140,
                      width: 110,
                      fromProductDetails: false,
                      ),
                ],
              ),
            ],
          ),
        ),
        //packetselection
        const SelectCountWeight()
      ],
    );
  }
}
