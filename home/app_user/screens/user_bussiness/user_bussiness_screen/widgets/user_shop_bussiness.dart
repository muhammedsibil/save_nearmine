import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_bussiness/provider/provider_bussiness.dart';
import 'package:near_mine/home/app_bussiness/screens/product_upload_screen/product_upload.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_bussiness_seemore/user_see_more_detailscreen.dart';
import 'package:provider/provider.dart';

import '../../../../../../constant/constant.dart';
import '../../../../../../find_city/provider/data.dart';
import '../../../../../app_bussiness/screens/my_shop_screen/screens/my_shop_screen/widgets/category_horizontal.dart';
import '../../../../provider/provider_user.dart';
import '../../../../widgets/product_detail.dart/screen/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'user_shop_category.dart';

class UserShopBussiness extends StatefulWidget {
  const UserShopBussiness({
    Key? key,
    required this.shopNumber,
    required this.shopName,
  }) : super(key: key);
  final String shopNumber;
  final String shopName;
  @override
  State<UserShopBussiness> createState() => _UserShopBussinessState();
}

class _UserShopBussinessState extends State<UserShopBussiness> {
  String _city = "";
  String _subCity = "";

  List<String> _categoryList = [];

  String shopName = "shop name";
  String number = "9995498550";

  @override
  void initState() {
    super.initState();
    final store = Provider.of<CityModel>(context, listen: false);
    _city = store.city;
    _subCity = store.subCity;

    getLists();
  }

  Future<void> getLists() async {
    Query<Map<String, dynamic>> colRef = FirebaseFirestore.instance
        .collection("Place")
        .doc(_city)
        .collection("SubCity")
        .doc(_subCity)
        .collection("Shop")
        .doc(widget.shopNumber)
        .collection("Category")
        .limit(4);
    QuerySnapshot docSnap = await colRef.get();
    List<String> categoryList = [];
    docSnap.docs.forEach(
      (elements) {
        categoryList.add(elements.id);
      },
    );
    if (mounted) {
      setState(() {
        _categoryList = categoryList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var shopNumber = widget.shopNumber;
    var shopName = widget.shopName;
    print("cc : $shopNumber");
    if (_categoryList.isEmpty) {
      return const ListTile(title: Center(child: Text("Not available")));
    }
    if (!_categoryList.isNotEmpty) {
      return const CircularProgressIndicator();
    }

    return Center(
      child: Column(
        children: [
          CategoryHorizontal(
            categoryList: _categoryList,
            city: _city,
            subCity: _subCity,
            shopName: shopName,
            bussinessNumber: shopNumber,
          ),
          UserShopCategory(
            categoryList: _categoryList,
            city: _city,
            subCity: _subCity,
            shopName: shopName,
            shopNumber: shopNumber,
          )
        ],
      ),
    );
  }

  uploadProduct({category, categoryList}) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
        alignment: Alignment.center,
        child: const CircleAvatar(
          // minRadius: 13,
          maxRadius: 14,
          child: Icon(Icons.add),
        ),
      ),
      onTap: () {
        context.read<ProviderBussiness>().addCategory(category);
        context.read<ProviderBussiness>().addCategories(categoryList);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductUpload(
              categoryPass: category,
            ),
          ),
        );
      },
    );
  }
}
