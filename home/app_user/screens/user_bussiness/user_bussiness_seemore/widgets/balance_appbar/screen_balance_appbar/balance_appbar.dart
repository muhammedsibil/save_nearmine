import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../models/product_model.dart';
import '../../../../../../provider/provider_user.dart';
import '../widget_balance_appbar/select_count_machine.dart';
import '../widget_balance_appbar/select_count_weight.dart';
import '../widget_balance_appbar/select_weight_machine.dart';

enum Productbuy { weightMachine, count }

class BalancerAppBar extends StatefulWidget {
  const BalancerAppBar({Key? key, required this.product, required this.bal})
      : super(key: key);

  final List<Map<String, dynamic>> product;
  final Function bal;
  @override
  State<BalancerAppBar> createState() => _BalancerAppBarState();
}

class _BalancerAppBarState extends State<BalancerAppBar> {
  double totalweight = 0.0;

  var _selectedProductbuy = "";
  @override
  Widget build(BuildContext context) {
    var selectedProductbuyCount =
        Provider.of<ProviderUser>(context, listen: true).selectionCountWeight;
    bool selectedProductbuy = selectedProductbuyCount == "count";
    var product = widget.product;

    String valuePrice = product.last['price'] ?? '0';

    double price = double.parse(valuePrice);

    double totalweight = context.watch<ProviderUser>().totalWeightt;

    var value = price * totalweight;

    var totalPrice = value.round();
    var totalValue = totalPrice == 0 ? price : totalPrice;
    bool yes = totalweight < 1;
    var proTotalWeight;
    final String weightUnit;
    if (yes) {
      if (totalweight == 0) {
        if (product.length > 1) {
          proTotalWeight = 1;
        } else {
          proTotalWeight = 0;
        }
      } else {
        proTotalWeight = totalweight * 1000;
      }
      if (totalweight == 0) {
        weightUnit = " KG";
      } else {
        weightUnit = " G";
      }
    } else {
      proTotalWeight = totalweight;
      weightUnit = " KG";
    }

    return selectedProductbuy
        ?  SelectCountMachine(
           price: price,
            proTotalWeight: proTotalWeight,
            product: product,
            selectedProductbuy: selectedProductbuy,
            totalPrice: totalPrice,
            totalValue: totalValue,
            weight: weight,
            weightUnit: weightUnit,
            yes: yes,
        )
        : SelectWeightMachine(
            price: price,
            proTotalWeight: proTotalWeight,
            product: product,
            selectedProductbuy: selectedProductbuy,
            totalPrice: totalPrice,
            totalValue: totalValue,
            weight: weight,
            weightUnit: weightUnit,
            yes: yes,
          );
  }

  List weight = [
    {
      'weight': 0.010,
      'width': 1.0,
      'hieght': 4.0,
    },
    {
      'weight': 0.050,
      'width': 1.0,
      'hieght': 4.0,
    },
    {
      'weight': 0.100,
      'width': 1.0,
      'hieght': 4.3,
    },
    {
      'weight': 0.200,
      'width': 1.0,
      'hieght': 4.7,
    },
    {
      'weight': 0.300,
      'width': 1.0,
      'hieght': 4.9,
    },
    {
      'weight': 0.500,
      'width': 1.0,
      'hieght': 5.3,
    },
    {
      'weight': 1,
      'width': 1.0,
      'hieght': 6.0,
    },
    {
      'weight': 2,
      'width': 3.0,
      'hieght': 6.5,
    },
    {
      'weight': 5,
      'width': 3.0,
      'hieght': 6.7,
    },
    {
      'weight': 10,
      'width': 3,
      'hieght': 7.0,
    },
    {
      'weight': 20,
      'width': 3,
      'hieght': 7.5,
    },
    {
      'weight': 30,
      'width': 3,
      'hieght': 7.5,
    },
    {
      'weight': 50,
      'width': 3,
      'hieght': 7.5,
    },
    {
      'weight': 100,
      'width': 3,
      'hieght': 7.5,
    },
  ];
}
