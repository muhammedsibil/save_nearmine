import 'package:flutter/material.dart';
import 'package:near_mine/home/app_bussiness/screens/bussiness_screen/widgets/user_shop_cart.dart';

import 'widgets/shops_list.dart';

class BussinesScreen extends StatefulWidget {
  const BussinesScreen({
    Key? key,
     this.subCity,
  }) : super(key: key);
  final String? subCity;
  @override
  State<BussinesScreen> createState() => _BussinesScreenState();
}

class _BussinesScreenState extends State<BussinesScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      body: ShopsList(),
      floatingActionButton: UserShopCartMessageIcon(isChatIcon: true),
    );
  }
}


// class CategoriesShop extends StatefulWidget {
//   const CategoriesShop({Key? key}) : super(key: key);

//   @override
//   State<CategoriesShop> createState() => _CategoriesShopState();
// }

// class _CategoriesShopState extends State<CategoriesShop> {
//   String _city = "";

//   String _subCity = "";

//   String shopName = "shop name";
//   String number = "9995498550";
//   var listt;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     final store = Provider.of<CityModel>(context, listen: false);
//     _city = store.city;
//     _subCity = store.subCity;

//     getLists();
//   }

//   List<String> categoryList = [];

//   Future<List> getLists() async {
//     CollectionReference colRef = FirebaseFirestore.instance
//         .collection("Place")
//         .doc(_city)
//         .collection("SubCity")
//         .doc(_subCity)
//         .collection("Shop")
//         .doc("9995498550")
//         .collection("Category");
//     QuerySnapshot docSnap = await colRef.get();
//     docSnap.docs.forEach(
//       (elements) {
//         categoryList.add(elements.id);

//         if (categoryList.length == docSnap.docs.length) print("heloooooojjj");
//         context.read<ProviderBussiness>().addCategories(categoryList);
//         setState(() {});
//       },
//     );
//     return categoryList;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (categoryList.length == 0) {
//       print("No collection");
//       return uploadProduct();
//     }
//     if (!categoryList.isNotEmpty) {
//       return CircularProgressIndicator();
//     }
//     return Center(
//       child: Column(
//         children: [
//           ListView.builder(
//             padding: EdgeInsets.symmetric(vertical: 16),
//             physics: NeverScrollableScrollPhysics(),
//             shrinkWrap: true,
//             itemCount: categoryList.length,
//             itemBuilder: (BuildContext context, int i) {
//               return FutureBuilder<QuerySnapshot>(
//                 future: FirebaseFirestore.instance
//                     .collection("Place")
//                     .doc(_city)
//                     .collection("SubCity")
//                     .doc(_subCity)
//                     .collection("Shop")
//                     .doc("9995498550")
//                     .collection("Category")
//                     .doc(categoryList[i])
//                     .collection("Product")
//                     .limit(6)
//                     .orderBy("time")
//                     .get(),
//                 builder:
//                     (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
//                   if (snapshot.data?.size == 0) {
//                     print("No collection");
//                     return uploadProduct(category: categoryList[i]);
//                   }
//                   if (!snapshot.hasData) {
//                     return CircularProgressIndicator();
//                   }
//                   return ListTile(
//                     tileColor: Colors.blue.withOpacity(0.02),
//                     contentPadding:
//                         EdgeInsets.symmetric(vertical: 6, horizontal: 6),
//                     title: Text(categoryList[i].toUpperCase(),
//                         style: Constant.categoryHeading),
//                     subtitle: Container(
//                       color: Colors.blue.withOpacity(0.03),
//                       padding: EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           GridView.builder(
//                             physics: const NeverScrollableScrollPhysics(),
//                             shrinkWrap: true,
//                             gridDelegate:
//                                 const SliverGridDelegateWithFixedCrossAxisCount(
//                               crossAxisSpacing: 10,
//                               crossAxisCount: 3,
//                             ),
//                             itemCount: snapshot.data!.docs.length + 1,
//                             itemBuilder: (BuildContext context, int index) {
//                               if (index == 0) {
//                                 print(categoryList[i]);

//                                 return uploadProduct(category: categoryList[i]);
//                               }
//                               QueryDocumentSnapshot data =
//                                   snapshot.data!.docs[index - 1];
//                               // var v = snapshot.data!.docs[index - 1]['priority'];

//                               // String category = data['category'] ?? "";
//                               String name = data['pro_name'] ?? "";
//                               String price = data['pro_price'] ?? "";
//                               // String userMail = data['user'] ?? "";
//                               List urlImage = data['lis'] ?? [];

//                               return Column(children: [
//                                 CachedNetworkImage(
//                                   imageUrl: urlImage[0],
//                                   imageBuilder: (context, imageProvider) =>
//                                       GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (BuildContext context) =>
//                                               DetailScreen(
//                                             name: name,
//                                             price: price,
//                                             category: categoryList[index],
//                                             uploadProduct: uploadProduct(
//                                                 category: categoryList[i]),
//                                             urlImage: urlImage[0],
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: Container(
//                                       height: 80,
//                                       alignment: Alignment.center,
//                                       decoration: BoxDecoration(
//                                         color: Colors.amber,
//                                         borderRadius: BorderRadius.circular(15),
//                                         image: DecorationImage(
//                                           image: imageProvider,
//                                           fit: BoxFit.cover,
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   placeholder: (context, url) =>
//                                       CircularProgressIndicator(),
//                                   errorWidget: (context, url, error) =>
//                                       Icon(Icons.error),
//                                 ),
//                                 Center(child: Text(name)),
//                               ]);
//                             },
//                           ),
//                           TextButton(
//                               onPressed: () {
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (BuildContext context) => BussinessSeeMore(
//                                       category: categoryList[i],
//                                       city: _city,
//                                       subCity: _subCity,
//                                       uploadProduct: uploadProduct(
//                                           category: categoryList[i]),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Text("See more")),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget uploadProduct({category}) {
//     return GestureDetector(
//       child: Container(
//         padding: EdgeInsets.symmetric(horizontal: 1, vertical: 1),
//         alignment: Alignment.center,
//         child: CircleAvatar(
//           // minRadius: 13,
//           maxRadius: 14,
//           child: Icon(Icons.add),
//         ),
//       ),
//       onTap: () {
//         context.read<ProviderBussiness>().addCategory(category);
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductUpload(
//               categoryPass: category,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
