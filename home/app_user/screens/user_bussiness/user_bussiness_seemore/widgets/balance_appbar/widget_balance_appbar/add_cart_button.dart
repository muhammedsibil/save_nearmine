import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../models/product_model.dart';
import '../../../../../../provider/provider_user.dart';

class AddtoCartButton extends StatefulWidget {
  const AddtoCartButton(
      {super.key,
      required this.product,
      required this.totalValue,
      required this.proTotalWeight,
      required this.weightUnit,
      required this.width,
      required this.height,
      required this.fromProductDetails,
      this.itemCount});
  final List<Map<String, dynamic>> product;
  final num totalValue;
  final dynamic proTotalWeight;
  final String weightUnit;
  final dynamic itemCount;
  final double width;
  final double height;
  final bool fromProductDetails;
  @override
  State<AddtoCartButton> createState() => _AddtoCartButtonState();
}

class _AddtoCartButtonState extends State<AddtoCartButton> {
  fromBalancerToCart() {
    if (widget.product.length > 1) {
      context.read<ProviderUser>().addSelectCartTrue();
      context.read<ProviderUser>().removeProductOn();
    } else {
      context.read<ProviderUser>().addSelectCartFalse();
    }
  }

  fromProductDetailsToCart() {
    // context.read<ProviderUser>().addSelectCartTrue();
    context.read<ProviderUser>().cartSelected
        ? context.read<ProviderUser>().addSelectCartFalse()
        : context.read<ProviderUser>().addSelectCartTrue();

    Future.delayed(const Duration(milliseconds: 1000), () {
      context.read<ProviderUser>().addSelectCartFalse();
    });
  }

  @override
  Widget build(BuildContext context) {
    var product = widget.product;
    var totalValue = widget.totalValue;
    var proTotalWeight = widget.proTotalWeight;
    var weightUnit = widget.weightUnit;
    var itemCount = widget.itemCount;
    var width = widget.width;
    var height = widget.height;
    // print(product);
// height: 140,
//       width: 110,
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(width, height),
        backgroundColor: product.length == 1
            ? width == 130
                ? Colors.blue
                : Colors.blue.shade700
            : Colors.blue,
      ),
      // hoverColor: Colors.red,
      onPressed: () {
        var name = product.last['name'];
        var image = product.last['image'];
        var shopName = product.last['shopName'];
        var number = product.last['number'];
        print(shopName);
        print("nu: $number");
        print(product);
        // var itemCount = product.last['itemCount'];
        // var weight = product.last['weight'];
        // var weightUnit= product.last['weightUnit'];
        // var itemCount= product.last['itemCount'];

        print(product.last['weight']);

        if (!(name == "pp" && totalValue == 0)) {
          context.read<ProviderUser>().addCart(ProductModel(
                name: name,
                image: image,
                totalPrice: totalValue,
                shopName: shopName,
                number: number,
                itemCount: itemCount ?? 0,
                weight: proTotalWeight.toString(),
                weightUnit: weightUnit,
              ));
        }
        context.read<ProviderUser>().addToBalancerTwo();
        if (widget.fromProductDetails) {
          fromProductDetailsToCart();
        } else {
          fromBalancerToCart();
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.add_circle_outline, color: Colors.white),
          Text(
            "Add to cart",
            overflow: TextOverflow.clip,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
