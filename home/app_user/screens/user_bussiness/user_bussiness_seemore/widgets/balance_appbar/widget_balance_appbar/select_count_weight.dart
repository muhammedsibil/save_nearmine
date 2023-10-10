import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../provider/provider_user.dart';
import '../screen_balance_appbar/balance_appbar.dart';

class SelectCountWeight extends StatefulWidget {
  const SelectCountWeight({
    super.key,
  });
  // final String selectedProductbuy;
  @override
  State<SelectCountWeight> createState() => _SelectCountWeightState();
}

class _SelectCountWeightState extends State<SelectCountWeight> {
  // var selectedProductbuy = "";
  @override
  Widget build(BuildContext context) {
    var selectedProductbuy =
        Provider.of<ProviderUser>(context, listen: true).selectionCountWeight;
    return Positioned(
      right: 10,
      child: Row(
        children: [
          Text(selectedProductbuy == "count" ? 'Count' : "Weight Machine",
              style: TextStyle(color: Colors.black.withOpacity(0.5))),
          PopupMenuButton<Productbuy>(
            icon: Icon(
              Icons.more_vert,
              color: Colors.black.withOpacity(0.5),
            ),
            onSelected: (Productbuy item) {
              Provider.of<ProviderUser>(context, listen: false)
                  .addSelectionCountWeight(item.name);
              // setState(() {
              //   selectedProductbuy = item.name;

              //   print(selectedProductbuy);
              // });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<Productbuy>>[
              PopupMenuItem<Productbuy>(
                value: Productbuy.weightMachine,
                child: Text(
                  'Weight Machine',
                  style: TextStyle(
                      color: selectedProductbuy == "weightMachine"
                          ? Colors.green
                          : null),
                ),
              ),
              PopupMenuItem<Productbuy>(
                value: Productbuy.count,
                child: Text(
                  'Count',
                  style: TextStyle(
                      color:
                          selectedProductbuy == "count" ? Colors.green : null),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
