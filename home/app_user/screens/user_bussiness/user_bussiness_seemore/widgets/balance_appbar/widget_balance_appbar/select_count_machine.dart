import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import '../../../../../../provider/provider_user.dart';
import 'add_cart_button.dart';
import 'select_count_weight.dart';

class SelectCountMachine extends StatefulWidget {
  const SelectCountMachine(
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
  State<SelectCountMachine> createState() => _SelectCountMachineState();
}

class _SelectCountMachineState extends State<SelectCountMachine> {
  int _count = 1;
  int animationDelay = 3000;

// Function to increase the cart count
  checkProductOnMachine(emptyProduct, twoProductOnMachine) {
    if (emptyProduct) {
      if (twoProductOnMachine) {
        setState(() {
          _count = 1;
        });
      }
      setState(() {
        _count = 1;
      });
    }
  }

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

    var totalValue = price * _count;
    var emptyProduct = context.watch<ProviderUser>().product.length == 1;
    var twoProductOnMachine = context.watch<ProviderUser>().product.length == 2;
    // var sixProductOnMachine = context.watch<ProviderUser>().product.length == 6;

    checkProductOnMachine(emptyProduct, twoProductOnMachine);

    return Stack(
      children: [
        Container(
          color: Colors.grey.withOpacity(0.3),
          height: 300,
          width: MediaQuery.of(context).size.width,
        ),
        Positioned(
          left: 0,
          child: Container(
            height: 300,
            width: 140,
            padding: EdgeInsets.all(10),
            color: Colors.white.withOpacity(.3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "RS: ${totalValue.toString()}",
                  style: TextStyle(color: Colors.black, fontSize:totalValue.toString().length>8?16: 19,
                  
                 ),
                ),
                Text(
                  emptyProduct ? "Count: 0" : "Count: ${_count.toString()}",
                  style: TextStyle(color: Colors.black, fontSize: 10),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 10,
          bottom: 10,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              border: Border.all(color: Colors.grey),
              // border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        AnimatedPositioned(
          height: context.watch<ProviderUser>().selected
              ? 160 * _count.toDouble()
              : 100 * _count.toDouble(),
          width: context.watch<ProviderUser>().selected
              ? 160 * _count.toDouble()
              : 100 * _count.toDouble(),
          left: context.watch<ProviderUser>().selected ? 60 : 24,
          bottom: context.watch<ProviderUser>().selected ? 60 : 24.0,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
          child: GestureDetector(
            onTap: () {
              // bool selected = false;

              context.read<ProviderUser>().addSelect();
              // setState(() {
              //   _changeRotation();
              //   selected = !selected;
              // });
            },
            child: AnimatedRotation(
              turns: context.watch<ProviderUser>().turns,
              curve: Curves.bounceIn,
              duration: Duration(milliseconds: animationDelay),
              child: (widget.product.length == 1)
                  ? const SizedBox()
                  : Stack(
                      children: [
                        for (var i = 0.0; i < _count; i++)
                          if (i < 3)
                            Positioned(
                              height: 100,
                              width: 100,
                              left: 15 * i.toDouble(),
                              bottom: 15 * i.toDouble(),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(15),
                                  image: DecorationImage(
                                    image: NetworkImage(image),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (widget.product.length > 1)
                                      context
                                          .read<ProviderUser>()
                                          .removeProduct(product.last['name']);
                                  },
                                  icon: Icon(Icons.close),
                                ),
                              ),
                            )
                      ],
                    ),
            ),
          ),
        ),
        Positioned(
          right:
              _count > 3 ? 130 : (MediaQuery.of(context).size.width - 80) / 2,
          bottom: 10,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(40, 60),
                      backgroundColor:
                          _count > 5 ? Colors.blue.withOpacity(0.9) : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _count++;
                      });
                    },
                    child: Icon(
                      Icons.add,
                      color: _count > 5 ? Colors.white : null,
                    ),
                  ),
                  Text(emptyProduct ? '0' : ' $_count',
                      style: Theme.of(context).textTheme.headlineSmall),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      minimumSize: Size(40, 60),
                      backgroundColor:
                          _count > 5 ? Colors.blue.withOpacity(0.9) : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (_count > 1) {
                          _count--;
                        }
                      });
                    },
                    child: Icon(
                      Icons.remove,
                      color: _count > 5 ? Colors.white : null,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SelectCountWeight(),
        Positioned(
          bottom: 4,
          right: 2,
          child: AddtoCartButton(
            product: product,
            totalValue: totalValue,
            proTotalWeight: proTotalWeight,
            weightUnit: weightUnit,
            itemCount: _count,
            height: 140,
            width:110,
            fromProductDetails: false,
          ),
        ),
        if (_count > 3)
          Positioned(
            height: 40,
            width: 40,
            top: 30,
            left: 124,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              width: 40,
              height: 40,
              child: Text(_count.toString(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
      ],
    );
  }
}

