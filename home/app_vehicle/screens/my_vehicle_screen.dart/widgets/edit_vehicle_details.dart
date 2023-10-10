import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/find_city/provider/data.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';

class EditVehicleDetails extends StatefulWidget {
  const EditVehicleDetails({super.key, this.data});
  final data;
  @override
  State<EditVehicleDetails> createState() => _EditVehicleDetailsState();
}

var selectedIndex;
var selectedColor;
TextEditingController nameController = TextEditingController();
TextEditingController numberController = TextEditingController();
TextEditingController priceController = TextEditingController();

class _EditVehicleDetailsState extends State<EditVehicleDetails> {
  @override
  Widget build(BuildContext context) {
    var fv = Provider.of<CityModel>(context, listen: false);
    final String name = widget.data["name_driver"] ?? "Name";
    final String price = widget.data["price_driver"] ?? "Price";
    final String number = widget.data["number_driver"] ?? "Number";
    final bool isName = name != "Name";
    final bool isPrice = price != "Price";
    final bool isNumber = number != "Number";
    return IconButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              // backgroundColor: Colors.green,
              builder: (context) {
                // totalSingleBasket();

                var child;
                return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.80,
                    minChildSize: 0.26,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      child ??= DefaultTabController(
                        length: 2,
                        child: StatefulBuilder(
                          builder: (BuildContext context,
                              void Function(void Function()) setState) {
                            return Stack(
                              children: [
                                SingleChildScrollView(
                                  controller: scrollController,
                                  child: Column(
                                    children: [
                                      Padding(padding: EdgeInsets.all(15)),
                                      textField(
                                        iconWidget: Icon(Icons.person),
                                        read: isName,
                                        controller: nameController,
                                        hint: name,
                                        type: TextInputType.name,
                                      ),
                                      textField(
                                        iconWidget: Icon(Icons.call),
                                        read: isNumber,
                                        controller: numberController,
                                        hint: number,
                                        type: TextInputType.number,
                                      ),
                                      textField(
                                        iconWidget: Icon(Icons.money),
                                        read: isPrice,
                                        controller: priceController,
                                        hint: price,
                                        type: TextInputType.number,
                                      ),
                                      // OrderAccept(scrollController: scrollController),
                                      // Container(
                                      //   padding: EdgeInsets.only(bottom: 100),
                                      //   // height:
                                      //   //     MediaQuery.of(context).size.height,
                                      //   child: Container(
                                      //     margin: const EdgeInsets.all(4),
                                      //     color: Colors.white.withOpacity(1),
                                      //     child: Column(
                                      //       crossAxisAlignment:
                                      //           CrossAxisAlignment.start,
                                      //       children: [
                                      //         SizedBox(
                                      //           width: double.infinity,
                                      //           height: 130,
                                      //           child: ListView.builder(
                                      //             shrinkWrap: true,
                                      //             physics:
                                      //                 const BouncingScrollPhysics(),
                                      //             scrollDirection:
                                      //                 Axis.horizontal,
                                      //             itemCount: 13,
                                      //             itemBuilder:
                                      //                 (context, index) {
                                      //               return Padding(
                                      //                 padding:
                                      //                     const EdgeInsets.all(
                                      //                         8.0),
                                      //                 child: Row(
                                      //                   children: [
                                      //                     Column(
                                      //                       crossAxisAlignment:
                                      //                           CrossAxisAlignment
                                      //                               .start,
                                      //                       mainAxisSize:
                                      //                           MainAxisSize
                                      //                               .min,
                                      //                       children: [
                                      //                         Stack(
                                      //                           children: [
                                      //                             Positioned(
                                      //                               top: 4,
                                      //                               right: 4,
                                      //                               child:
                                      //                                   Container(
                                      //                                 width:
                                      //                                     40.0,
                                      //                                 height:
                                      //                                     40.0,
                                      //                                 child:
                                      //                                     ClipRRect(
                                      //                                   borderRadius:
                                      //                                       BorderRadius.circular(4.0),
                                      //                                   child:
                                      //                                       Container(
                                      //                                     decoration:
                                      //                                         BoxDecoration(
                                      //                                       border:
                                      //                                           Border.all(color: Colors.black.withOpacity(0.5), width: 2.0),
                                      //                                       color:
                                      //                                           Colors.transparent,
                                      //                                       shape:
                                      //                                           BoxShape.circle,
                                      //                                     ),
                                      //                                   ),
                                      //                                 ),
                                      //                               ),
                                      //                             ),
                                      //                             ElevatedButton(
                                      //                               style:
                                      //                                   ButtonStyle(
                                      //                                 fixedSize:
                                      //                                     MaterialStateProperty.all(Size(
                                      //                                         30,
                                      //                                         30)),
                                      //                                 minimumSize:
                                      //                                     MaterialStateProperty.all(Size(
                                      //                                         10,
                                      //                                         10)),
                                      //                                 shape: MaterialStateProperty
                                      //                                     .all(
                                      //                                   RoundedRectangleBorder(
                                      //                                     borderRadius:
                                      //                                         BorderRadius.circular(30.0),
                                      //                                   ),
                                      //                                 ),
                                      //                                 backgroundColor:
                                      //                                     MaterialStateProperty
                                      //                                         .all(
                                      //                                   selectedIndex ==
                                      //                                           index
                                      //                                       ? Colors.blue
                                      //                                       : Colors.grey[200],
                                      //                                 ),
                                      //                               ),
                                      //                               onPressed:
                                      //                                   () {
                                      //                                 setState(
                                      //                                     () {
                                      //                                   selectedIndex =
                                      //                                       index;
                                      //                                 });
                                      //                               },
                                      //                               child:
                                      //                                   Container(),
                                      //                             ),
                                      //                           ],
                                      //                         ),
                                      //                       ],
                                      //                     ),
                                      //                     Text(
                                      //                       " Plumber",
                                      //                       style: TextStyle(
                                      //                           fontSize: 14,
                                      //                           fontWeight:
                                      //                               FontWeight
                                      //                                   .w500,
                                      //                           color: Colors
                                      //                               .black
                                      //                               .withOpacity(
                                      //                                   selectedIndex ==
                                      //                                           index
                                      //                                       ? 1
                                      //                                       : 0.5)
                                      //                           // overflow: TextOverflow.ellipsis
                                      //                           ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               );
                                      //             },
                                      //           ),
                                      //         ),
                                      //       ],
                                      //     ),
                                      //   ),
                                      // )
                                 
                                    ],
                                  ),
                                ),
                                Positioned(
                                    // top: 0,
                                    bottom: MediaQuery.of(context)
                                        .viewInsets
                                        .bottom,
                                    right: 0,
                                    left: 0,
                                    child: Container(
                                      color: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              final doc = FirebaseFirestore
                                                  .instance
                                                  .collection("Place")
                                                  .doc("manjeri")
                                                  .collection("SubCity")
                                                  .doc("elankur")
                                                  .collection("vehicles")
                                                  .doc("7907156601");

                                              final String nameC =
                                                  nameController.text;
                                              final String priceC =
                                                  priceController.text;
                                              final String numberC =
                                                  numberController.text;

                                              await doc.update({
                                                "name_driver": nameC.isNotEmpty
                                                    ? nameC
                                                    : name,
                                                "number_driver":
                                                    numberC.isNotEmpty
                                                        ? numberC
                                                        : number,
                                                "price_driver":
                                                    priceC.isNotEmpty
                                                        ? priceC
                                                        : price,
                                              }).whenComplete(() {
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                fv.isUploading
                                                    ? CircularProgressIndicator()
                                                    : SizedBox(),
                                                const Text("Save"),
                                              ],
                                            )),
                                      ),
                                    ))
                              ],
                            );
                          },
                        ),
                      );

                      return child;
                    });
              });
        },
        icon: Icon(
          Icons.edit,
          color: Colors.black,
        ));
  }

  Widget textField(
      {dynamic hint, dynamic controller, dynamic type, read, iconWidget}) {
    String hintText = hint;
    return TextField(
      // readOnly: read,
      autofocus: !read,
      keyboardType: type,
      controller: controller,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: iconWidget,
        helperStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.grey,
          height: 1,
          // textAlign: TextAlign.left,
        ),
      ),
    );
    // return TextField(
    //   readOnly: false,
    //   autofocus: !read,
    //   maxLines: null,
    //   style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
    //   enableInteractiveSelection: false,
    //   keyboardType: type,
    //   controller: controller,
    //   decoration: InputDecoration(
    //     prefixIcon: Icon(Icons.person),
    //     hintText: hintText,
    //     helperStyle: const TextStyle(
    //       color: Colors.grey,
    //       fontSize: 16,
    //       fontWeight: FontWeight.w500,
    //     ),
    //     hintStyle: const TextStyle(
    //       fontSize: 16,
    //       fontWeight: FontWeight.w500,
    //       color: Colors.grey,
    //       height: 1,
    //       // textAlign: TextAlign.left,
    //     ),
    //     isCollapsed: true,
    //     contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
    //     prefixIconConstraints: const BoxConstraints(minWidth: 40, minHeight: 40),
    //     border: const UnderlineInputBorder(
    //       borderSide: BorderSide(color: Colors.grey),
    //     ),
    //     prefix: const SizedBox(width: 0.0, height: 48.0),
    //     // suffix: const SizedBox(width: 0.0, height: 48.0),
    //   ),
    // );
  }
}
