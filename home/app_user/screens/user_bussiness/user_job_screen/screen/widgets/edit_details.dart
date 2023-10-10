import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/find_city/provider/data.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditDetails extends StatefulWidget {
  const EditDetails({super.key, this.data});
  final data;
  @override
  State<EditDetails> createState() => _EditDetailsState();
}

class _EditDetailsState extends State<EditDetails> {
  var selectedIndex;
  var selectedColor;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController priceController = TextEditingController();

  var number;
  getDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('stringValue') ?? '';
    });
    // String city = prefs.getString('city') ?? '';
    // String subCity = prefs.getString('subCity') ?? '';
    // String ownership = prefs.getString('ownership') ?? '';
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getDetails();
  }

  List<String> categories = [
    'Electrician',
    'Plumber',
    'Welder',
    'Carpenter',
    'Painter',
    'Mason',
    'Tile Installer',
    'Interior Designer',
    'Bike Mechanic',
    'Auto Mechanic',
    'Teacher',
    'Other'
  ];

  String? selectedCategory;

  void selectCategory(String? category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    var fv = Provider.of<CityModel>(context, listen: false);
    final String name = widget.data?["name_driver"] ?? "Name";
    final String price = widget.data?["price_driver"] ?? "Price";
    // final String number = widget.data?["number_driver"] ?? "Number";
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
                                      SizedBox(
                                        width: double.infinity,
                                        height: 50,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: categories.length,
                                          itemBuilder: (context, index) {
                                            final category = categories[index];

                                            return SizedBox(
                                              width: 156,
                                              child: RadioListTile(
                                                title: Text(
                                                  category,
                                                  style: const TextStyle(
                                                      fontSize: 14),
                                                  maxLines: 2,
                                                ),
                                                value: category,
                                                groupValue: selectedCategory,
                                                onChanged: (value) {
                                                  var hh = value as String;
                                                  selectCategory(hh);
                                                  setState(() {});
                                                },
                                              ),
                                            );
                                          },
                                        ),
                                      )
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
                                              var city = "manjeri";
                                              var subCity = "elankur";
                                              // var number =
                                              //     "9061615995"; // Assuming this is the document ID

                                              final doc = FirebaseFirestore
                                                  .instance
                                                  .collection("Place")
                                                  .doc(city)
                                                  .collection("SubCity")
                                                  .doc(subCity)
                                                  .collection("Jobs")
                                                  .doc(number);

                                              String? nameC =
                                                  nameController.text;
                                              String? priceC =
                                                  priceController.text;
                                              String? numberC =
                                                  numberController.text;

                                              final docSnapshot =
                                                  await doc.get();

                                              if (docSnapshot.exists) {
                                                await doc.update({
                                                  if (nameC != null &&
                                                      nameC.isNotEmpty)
                                                    "user_name": nameC,
                                                  if (numberC != null &&
                                                      numberC.isNotEmpty)
                                                    "user_number": numberC,
                                                  if (number != null &&
                                                      number.isNotEmpty)
                                                    "user_id": number,
                                                  if (priceC != null &&
                                                      priceC.isNotEmpty)
                                                    "user_price": priceC,
                                                  "user_status": "",
                                                  "user_type":
                                                      (selectedCategory != null)
                                                          ? selectedCategory
                                                          : "Other",
                                                }).then((_) {
                                                  print(
                                                      "Document updated successfully");
                                                  Navigator.pop(context);
                                                }).catchError((error) {
                                                  print(
                                                      "Failed to update document: $error");
                                                });
                                              } else {
                                                await doc.set(
                                                  {
                                                    "user_name":
                                                        nameC.isNotEmpty
                                                            ? nameC
                                                            : "name",
                                                    "user_number":
                                                        numberC.isNotEmpty
                                                            ? numberC
                                                            : "number",
                                                    if (number != null &&
                                                        number.isNotEmpty)
                                                      "user_id": number,
                                                    "user_price":
                                                        priceC.isNotEmpty
                                                            ? priceC
                                                            : "price",
                                                    "user_status": "",
                                                    "user_type":
                                                        (selectedCategory !=
                                                                null)
                                                            ? selectedCategory
                                                            : "",
                                                  },
                                                );
                                                Navigator.pop(context);
                                              }
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
  }
}

class SelectRadioButton extends StatefulWidget {
  const SelectRadioButton({super.key, required this.valueString, this.child});
  final String valueString;
  final Widget? child;

  @override
  State<SelectRadioButton> createState() => _SelectRadioButtonState();
}

class _SelectRadioButtonState extends State<SelectRadioButton> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: RadioListTile(
        title: widget.child,
        value: widget.valueString,
        groupValue: selectedOption,
        onChanged: (value) {
          setState(() {
            selectedOption = value as String?;
          });
          // saveOptionToFirestore(value);
        },
      ),
    );
  }
}
