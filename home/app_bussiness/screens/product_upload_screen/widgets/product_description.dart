import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../find_city/provider/data.dart';
import '../../../provider/provider_bussiness.dart';

enum Option { zero, One_Kilo, One_Quintal, One_Ton }

class ProductDescription extends StatefulWidget {
  final String? categoryPass;
  final String? category;
  TextEditingController pro_name;
  TextEditingController pro_price;
  var storeMessage;
  Function toImage;
  List<String> imageListFetched;
  List<String> imageList;
  bool imageUploadCompleted;
  Function uploadImagesAndDescriptions;

  ProductDescription(
      {Key? key,
      required this.category,
      required this.pro_name,
      required this.pro_price,
      this.storeMessage,
      required this.toImage,
      required this.imageListFetched,
      required this.imageList,
      required this.imageUploadCompleted,
      required this.uploadImagesAndDescriptions,
      this.categoryPass})
      : super(key: key);

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  TextEditingController categoryController = TextEditingController();

  String _selectedWeightUnit = "";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var uploadCategory = context.watch<ProviderBussiness>().uploadCategory;
    var city = context.watch<CityModel>().city;
    var subCity = context.watch<CityModel>().subCity;
    var number = context.watch<CityModel>().numberShop;
    var nameShop = context.watch<CityModel>().nameShop;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  var providerBussiness = context.read<ProviderBussiness>();
                  var categoryLocal = providerBussiness.categoryLocal;
                  var categories = providerBussiness.categories;
                  var categoryController = TextEditingController();
                  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: FirebaseFirestore.instance
                        .collection("Place")
                        .doc(city.toLowerCase())
                        .collection("SubCity")
                        .doc(subCity.toLowerCase())
                        .collection("Shop")
                        .doc(number)
                        .collection("Category")
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                            snapshot) {
                      if (snapshot.hasError)
                        return Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        default:
                          // List<DropdownMenuItem<String>> items = [];
                          // for (QueryDocumentSnapshot<
                          //         Map<String, dynamic>> category
                          //     in snapshot.data!.docs) {
                          //   final String? name = category.data()['name'];
                          //   items.add(DropdownMenuItem<String>(
                          //     value: name!,
                          //     child: Text(name),
                          //   ));
                          // }
                          return AlertDialog(
                            title: Text('Add Category'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 8),
                                  Text('Select a category or enter a new one:'),
                                  SizedBox(height: 8),
                                  Container(
                                    height: 200,
                                    child: ListView.builder(
                                      itemCount: snapshot.data!.docs.length,
                                      reverse: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final category =
                                            snapshot.data!.docs[index];
                                        final String? name =
                                            category.data()['category_name'] ??
                                                "dd";
                                        final int? color =
                                            category.data()['color'] ?? "11111";

                                        return ListTile(
                                          tileColor:
                                              Color(color!).withOpacity(0.5),
                                          title: Text(name!),
                                          onTap: () {
                                            _controller.text = name;
                                            providerBussiness
                                                .addCategoryLocal(name);
                                            providerBussiness.addCategory(name);
                                            Navigator.pop(context);
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  TextField(
                                    controller: _controller,
                                    decoration: InputDecoration(
                                      hintText: 'Or enter a new category',
                                    ),
                                    onSubmitted: (value) {
                                      providerBussiness.addCategoryLocal(value);
                                      providerBussiness.addCategory(value);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              ElevatedButton(
                                child: Text('Cancel'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              ElevatedButton(
                                child: Text('Add'),
                                onPressed: () {
                                  final String category =
                                      _controller.text.trim();
                                  if (category.isNotEmpty) {
                                    // FirebaseFirestore.instance
                                    //     .collection("Place")
                                    //     .doc(city.toLowerCase())
                                    //     .collection("SubCity")
                                    //     .doc(subCity.toLowerCase())
                                    //     .collection("Shop")
                                    //     .doc(number)
                                    //     .collection("Category")
                                    //     .add({'category_name': category});
                                    providerBussiness
                                        .addCategoryLocal(category);
                                    providerBussiness.addCategory(category);
                                  }
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                      }
                    },
                  );
                },
              );
            },
            child: InputDecorator(
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: uploadCategory,
                suffixIcon: Icon(Icons.keyboard_arrow_down),
              ),
              child: Text(
                uploadCategory,
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ),
        ),

        // Padding(
        //   padding: const EdgeInsets.all(10.0),
        //   child: TextField(
        //     readOnly: true,
        //     onTap: () {
        //       showDialog(
        //         context: context,
        //         builder: (_) {
        //           return StatefulBuilder(
        //             builder: (BuildContext context, StateSetter setState) {
        //               var categoryLocal =
        //                   context.watch<ProviderBussiness>().categoryLocal;
        //               var category =
        //                   context.watch<ProviderBussiness>().categories;
        //               return AlertDialog(
        //                 title: Text('Category'),
        //                 content: SingleChildScrollView(
        //                   child: Column(
        //                     children: [
        //                       TextField(
        //                         controller: categoryController,
        //                         onSubmitted: (value) {
        //                           context
        //                               .read<ProviderBussiness>()
        //                               .addCategoryLocal(value);
        //                           context
        //                               .read<ProviderBussiness>()
        //                               .addCategory(value);
        //                           Navigator.pop(context);
        //                         },
        //                         decoration: const InputDecoration(
        //                           contentPadding: EdgeInsets.all(16),
        //                           hintText: 'Add category',
        //                           suffixIcon: Icon(Icons.add),
        //                         ),
        //                       ),
        //                       SizedBox(height: 16),
        //                       Text("New"),
        //                       Column(
        //                         children: categoryLocal
        //                             .map((category) => TextButton(
        //                                   onPressed: () {
        //                                     context
        //                                         .read<ProviderBussiness>()
        //                                         .addCategory(category);
        //                                     Navigator.pop(context);
        //                                   },
        //                                   child: Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                       Text(category),
        //                                       IconButton(
        //                                         onPressed: () {
        //                                           context
        //                                               .read<ProviderBussiness>()
        //                                               .deleteCategoryLocal(
        //                                                   category);
        //                                         },
        //                                         icon: const Icon(Icons.remove),
        //                                       ),
        //                                     ],
        //                                   ),
        //                                 ))
        //                             .toList(),
        //                       ),
        //                       SizedBox(height: 16),
        //                       Container(
        //                         color: Colors.grey,
        //                         height: 1,
        //                         width: double.infinity,
        //                       ),
        //                       SizedBox(height: 16),
        //                       Column(
        //                         children: category
        //                             .map((e) => TextButton(
        //                                   onPressed: () {
        //                                     context
        //                                         .read<ProviderBussiness>()
        //                                         .addCategory(e);
        //                                     Navigator.pop(context);
        //                                   },
        //                                   child: Row(
        //                                     mainAxisAlignment:
        //                                         MainAxisAlignment.spaceBetween,
        //                                     children: [
        //                                       Text(e),
        //                                       Icon(Icons.arrow_forward),
        //                                     ],
        //                                   ),
        //                                 ))
        //                             .toList(),
        //                       ),
        //                     ],
        //                   ),
        //                 ),
        //               );
        //             },
        //           );
        //         },
        //       );
        //     },
        //     decoration: InputDecoration(
        //       contentPadding: EdgeInsets.all(16),
        //       // hintText: widget.categoryPass!.toUpperCase(),
        //       hintText: uploadCategory,
        //       suffixIcon: Icon(Icons.keyboard_arrow_down),
        //     ),
        //   ),
        // ),
        textField(
            controller: widget.pro_name,
            price: widget.pro_price.toString(),
            name: 'Name',
            type: TextInputType.name),
        textField(
            controller: widget.pro_price,
            price: widget.pro_price.toString(),
            name: 'Price',
            type: TextInputType.number),
        textField(
            controller: widget.pro_price,
            price: widget.pro_price.toString(),
            name: 'Descrption (optional)',
            type: TextInputType.number),
      ],
    );
  }

  Widget textField(
      {dynamic name, dynamic price, dynamic controller, dynamic type}) {
    String hintText = name;
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        style: TextStyle(fontSize: 16), // set the font size to 16
        enableInteractiveSelection: false,
        keyboardType: type,
        controller: controller,

        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: TextStyle(fontWeight: FontWeight.bold),
          // hintText:  '',
          isCollapsed: true,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          contentPadding:
              EdgeInsets.symmetric(vertical: 6, horizontal: 16), // modified
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey),
          ),
          // Additional padding for better alignment
          prefix: SizedBox(width: 0.0, height: 40.0),
          suffix: SizedBox(width: 0.0, height: 40.0),
        ),
      ),
    );
  }
}
