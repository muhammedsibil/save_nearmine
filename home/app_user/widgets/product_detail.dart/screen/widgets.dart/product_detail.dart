import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:near_mine/home/app_user/widgets/product_detail.dart/screen/widgets.dart/share_product.dart';
import 'package:near_mine/main.dart';
import 'package:provider/provider.dart';

import '../../../../../../utility/utility.dart';
import '../../../../../widget/image_3d.dart';
import '../../../../provider/provider_user.dart';
import '../../../../screens/user_bussiness/user_bussiness_seemore/widgets/balance_appbar/widget_balance_appbar/add_cart_button.dart';
import '../../../../screens/user_bussiness/user_job_screen/screen/user_job_screen.dart';
import 'description.dart';
import 'review.dart';

class ProductDetail extends StatefulWidget {
  final String category;
  final String name;
  final String price;
  final Widget? uploadProduct;
  final String urlImage;
  final String shopName;
  final String shopNumber;
  final String city;
  final String subCity;
  final List<Map<String, dynamic>> product;
  final String productId;

  const ProductDetail({
    super.key,
    required this.category,
    required this.name,
    required this.price,
    required this.urlImage,
    this.uploadProduct,
    required this.shopName,
    required this.shopNumber,
    required this.city,
    required this.subCity,
    required this.product,
    required this.productId,
  });

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  var cameras;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    camInit();
  }

  camInit() async {
    cameras = await availableCameras();
  }

  @override
  Widget build(BuildContext context) {
    var isProductDetails =
        (Provider.of<ProviderUser>(context, listen: false).isProductDetails);
    print("${widget.product} hy");
    return SliverAppBar(
      backgroundColor: Colors.white.withOpacity(1),
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            // width: MediaQuery.of(context).size.width,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: Colors.grey.withOpacity(0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: isProductDetails
                      ? Icon(Icons.close_outlined)
                      : Icon(Icons.arrow_back),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  padding: EdgeInsets.only(
                      left: isProductDetails ? 30 : 12, right: 12, bottom: 0),
                  splashColor: Colors.red,
                  iconSize: 24,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    isProductDetails ? "" : widget.category.toUpperCase(),
                    style: Business.headline5.copyWith(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer()
      ],
      snap: false,
      pinned: true,
      floating: false,
      expandedHeight: 799.0,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.pin,
        // expandedTitleScale: 100.0,
        background: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 799,
          backgroundColor: Colors.white,
          actions: [
            Column(
              children: [
                Image3D(
                  child: CachedNetworkImage(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    imageUrl: widget.urlImage,
                    imageBuilder: (context, imageProvider) => Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 8.0,
                      horizontal: widget.name.length > 16 ? 8 : 16.0),
                  child: Container(
                    // color: Colors.blue.shade100.withOpacity(0.10),
                    height: 230,
                    width: 320,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: widget.name.length > 16 ? 240 : null,
                                  child: Text(
                                    "${widget.name}",
                                    style: Business.headline5.copyWith(
                                        color: Colors.black.withOpacity(0.3),
                                        fontSize: 24),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  "₹${widget.price}",
                                  style: Business.headline5.copyWith(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 24),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ShirtMatch(
                                          shirt:widget.urlImage,
                                          cameras: cameras),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.face),
                              color: Colors.grey,
                            ),
                            ShareProduct(
                                number: widget.shopNumber,
                                city: widget.city,
                                subCity: widget.subCity,
                                price: widget.price,
                                category: widget.category,
                                urlImage: widget.urlImage),
                          ],
                        ),

                        Row(
                          children: [
                            const Spacer(),
                            AddtoCartButton(
                              product: widget.product,
                              totalValue: double.parse(widget.price),
                              proTotalWeight: "proTotalWeight",
                              weightUnit: "weightUnit",
                              itemCount: 1,
                              width: 130,
                              height: 60,
                              fromProductDetails: true,
                            ),
                          ],
                        ), //about product desc
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          // height: 30,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            // color: Colors.blue,
                            border: Border(
                                bottom: BorderSide(
                                    color: Colors.blueGrey.withOpacity(0.3))),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Description(name: widget.name),
                              Review(
                                name: widget.name,
                                shopName: widget.shopName,
                                category: widget.category,
                                shopNumber: widget.shopNumber,
                                city: widget.city,
                                subCity: widget.subCity,
                                productId: widget.productId,
                              ),

                              // Image.network(widget.urlImage,height: 30,width: 30,),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.delivery_dining,
                                    color: Colors.black54,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      context
                                          .read<ProviderUser>()
                                          .addSelectCartTrue;
                                    },
                                    child: const Text(
                                      "Free Delivery",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
