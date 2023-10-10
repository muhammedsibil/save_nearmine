import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../constant/constant.dart';

enum Menu { productSelect, itemTwo, itemThree, itemFour }

class BussinessSeeMore extends StatefulWidget {
  const BussinessSeeMore(
      {Key? key,
      required this.city,
      required this.subCity,
      required this.category,
      required this.uploadProduct})
      : super(key: key);

  final String city;
  final String subCity;
  final String category;
  final Widget uploadProduct;

  @override
  State<BussinessSeeMore> createState() => _BussinessSeeMoreState();
}

class _BussinessSeeMoreState extends State<BussinessSeeMore> {
  String _selectedMenu = "";
  @override
  Widget build(BuildContext context) {
    bool isSelected = _selectedMenu == "productSelect";
    print(_selectedMenu);
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            toolbarHeight: isSelected ? 160.0 : 60.0,
            actions: [],
          ),
          body: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection("Place")
                  .doc(widget.city)
                  .collection("SubCity")
                  .doc(widget.subCity)
                  .collection("Shop")
                  .doc("9995498550")
                  .collection("Category")
                  .doc(widget.category)
                  .collection("Product")
                  .limit(19)
                  .orderBy("time")
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                if (snapshot.data?.size == 0) {
                  print("No collection");
                  return widget.uploadProduct;
                }
                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                return ListTile(
                  tileColor: Colors.blue.withOpacity(0.02),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isSelected)
                        ListTile(
                          leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  _selectedMenu = "";
                                });
                              },
                              icon: Icon(Icons.close)),
                          title: Text('Select items'),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(widget.category.toUpperCase(),
                              style: Constant.categoryHeading),
                          PopupMenuButton<Menu>(
                            // Callback that sets the selected popup menu item.
                            onSelected: (Menu item) {
                              setState(() {
                                _selectedMenu = item.name;
                              });
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<Menu>>[
                              const PopupMenuItem<Menu>(
                                value: Menu.productSelect,
                                child: Text('Select Items'),
                              ),
                              const PopupMenuItem<Menu>(
                                value: Menu.itemTwo,
                                child: Text('Item 2'),
                              ),
                              const PopupMenuItem<Menu>(
                                value: Menu.itemThree,
                                child: Text('Item 3'),
                              ),
                              const PopupMenuItem<Menu>(
                                value: Menu.itemFour,
                                child: Text('Item 4'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  subtitle: Container(
                    color: Colors.blue.withOpacity(0.03),
                    padding: EdgeInsets.all(16),
                    child: Column(children: [
                      GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: 10,
                          crossAxisCount: 3,
                        ),
                        itemCount: snapshot.data!.docs.length + 1,
                        itemBuilder: (BuildContext context, int index) {
                          if (index == 0) {
                            return widget.uploadProduct;
                          }
                          QueryDocumentSnapshot data =
                              snapshot.data!.docs[index - 1];
                          // var v = snapshot.data!.docs[index - 1]['priority'];

                          String category = data['category'] ?? "";
                          String name = data['pro_name'] ?? "";
                          String price = data['pro_price'] ?? "";
                          // String userMail = data['user'] ?? "";
                          List urlImage = data['lis'] ?? [];

                          return Column(children: [
                            Stack(
                              alignment: Alignment.topRight,
                              children: [
                                Container(
                                  height: 80,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(15),
                                    image: DecorationImage(
                                      image: NetworkImage(urlImage[0]),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                if (_selectedMenu == "productSelect")
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RawMaterialButton(
                                      constraints: BoxConstraints(
                                          minWidth: 24, minHeight: 24),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      padding: EdgeInsets.all(6.0),
                                      onPressed: () {},
                                      elevation: 2.0,
                                      fillColor: Colors.white,
                                      child: Icon(
                                        Icons.add_shopping_cart_outlined,
                                        size: 14.0,
                                      ),
                                      // padding: EdgeInsets.all(0.0),
                                      shape: CircleBorder(),
                                    ),
                                  ),
                              ],
                            ),
                            Center(child: Text(name)),
                          ]);
                        },
                      ),
                      TextButton(
                          onPressed: () {
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (BuildContext context) =>
                            //             BussinessSeeMore(
                            //               category: categoryList[index],
                            //               city: _city,
                            //               subCity: _subCity,
                            //               upload: uploadProduct(),
                            //             )));
                          },
                          child: Text("See more")),
                    ]),
                  ),
                );
              })),
    );
  }
}
