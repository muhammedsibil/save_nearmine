import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:near_mine/home/app_bussiness/provider/provider_bussiness.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:path/path.dart' as path;
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../../../find_city/provider/data.dart';
import '../my_shop_screen/screens/my_shop_screen/widgets/category_horizontal.dart';

var uploadProgress;
// final List<XFile> selectedFiles = [];

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  final Map<Color, String> colorNames = {
    Colors.red[100]!: 'Red',
    Colors.blue[100]!: 'Blue',
    Colors.yellow[100]!: 'Yellow',
    Colors.orange[100]!: 'Orange',
    Colors.purple[100]!: 'Purple',
    Colors.pink[100]!: 'Pink',
    Colors.teal[100]!: 'Teal',
    Colors.brown[100]!: 'Brown',
    Colors.grey[100]!: 'Grey',
  };
  final TextEditingController _controller = TextEditingController();
  // final TextEditingController _pro_price = TextEditingController();
  // final TextEditingController _pro_name = TextEditingController();
  // final TextEditingController _pro_description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.grey,

      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Add product',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          Selector<CityModel, int>(
            selector: (context, cityModel) => cityModel.selectedFiles.length,
            builder: (context, count, child) {
              return TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.all(10)), // set the padding of the button
                    foregroundColor: MaterialStateProperty.all<Color>(
                      count == 0 ? Colors.black26 : Colors.black,
                    ),
                    // set the text color of the button

                    textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )), // set the text style of the button
                  ),
                  onPressed: () {
                    final cityProvider =
                        Provider.of<CityModel>(context, listen: false);
                    var productId = DateTime.now().millisecondsSinceEpoch;

                    var controller = _controller.text;

                    final String pro_name = cityProvider.proNameController.text;
                    final String pro_description =
                        cityProvider.proDescriptionController.text;
                    final String pro_price =
                        cityProvider.proPriceController.text;
                    final city = cityProvider.city;
                    final subCity = cityProvider.subCity;
                    final number = cityProvider.numberShop;
                    // final productId = cityProvider.productId;
                    final category = cityProvider.category;
                    cityProvider.isUploading = true;
                    cityProvider.addNameProduct(productId.toString());

                    if (cityProvider.selectedFiles.isNotEmpty &&
                        !(category == "") &&
                        pro_name.isNotEmpty &&
                        pro_price.isNotEmpty) {
                      uplo(cityProvider, controller, pro_name, pro_price,
                              pro_description)
                          .whenComplete(() {
                        // 'categories': FieldValue.arrayUnion(['new_category'])

                        FirebaseFirestore.instance
                            .collection("Place")
                            .doc(city)
                            .collection("SubCity")
                            .doc(subCity)
                            .collection("Shop")
                            .doc(number)
                            .update({
                          'categories': FieldValue.arrayUnion([category.trim()])
                        });

                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Upload has been done")));
                        }

                        cityProvider.isUploading = false;
                        cityProvider.clearSelectedFiles();
                        cityProvider.proNameController.clear();
                        cityProvider.proPriceController.clear();
                        cityProvider.proDescriptionController.clear();
                      });
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Full empty")));
                      }
                    }
                  },
                  child: Text("Save"));
            },
          ),
        ],
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Place")
                .doc("manjeri")
                .collection("SubCity")
                .doc("elankur")
                .collection("Shop")
                .doc("9995498550")
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return const Center(child: Text('Oops, something went wrong!'));
              }
              // final documentData = snapshot.data?.data() ?? {};

              final categoryDocs =
                  snapshot.data?.data() as Map<String, dynamic>? ?? {};
              ;

              if (categoryDocs.isEmpty) {
                return const Center(child: Text('No categories found.'));
              }

              final data = snapshot.data?.data() as Map;
              final categoryName = data['category_name'].toString();

              return Column(
                children: [
                  Container(
                    height: 179,
                    // color: Colors.red,
                    child: Row(
                      children: [
                        Provider.of<CityModel>(context, listen: true)
                                    .selectedFiles
                                    .length ==
                                0
                            ? SizedBox()
                            : Expanded(
                                flex: 3,
                                child: ListView(
                                  padding: EdgeInsets.only(right: 10),
                                  reverse: true,
                                  scrollDirection: Axis.horizontal,
                                  children: Provider.of<CityModel>(context,
                                          listen: true)
                                      .selectedFiles
                                      .reversed
                                      .map((e) => SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                2, // set the width to half the screen width

                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.file(File(e.path),
                                                  fit: BoxFit.cover),
                                            ),
                                          ))
                                      .toList()
                                      .cast<Widget>(),
                                ),
                              ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            height: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              border: Border.all(
                                color: Colors.grey,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  final cityProvider = Provider.of<CityModel>(
                                      context,
                                      listen: false);
                                  var nameProduct =
                                      DateTime.now().millisecondsSinceEpoch;
                                  final controller = _controller.text;

                                  cityProvider.clearDownloadUrls();

                                  selectAndUploadImage(
                                          cityProvider, nameProduct, controller)
                                      .whenComplete(() {
                                    // cityProvider.clearSelectedFiles();
                                  });
                                },
                                icon: const Icon(
                                  Icons.add_a_photo,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Provider.of<CityModel>(context, listen: false).isUploading
                      ? Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              backgroundColor: Colors.black,
                              color: Colors.green,
                              value:
                                  Provider.of<CityModel>(context, listen: false)
                                          .progress
                                          .toDouble() /
                                      130.0,
                            ),
                            SizedBox(
                              height: 10,
                              width: 10,
                              child: CircularProgressIndicator(
                                color: Colors.green.shade50,
                              ),
                            )
                          ],
                        )
                      : SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            final data =
                                Provider.of<CityModel>(context, listen: false);

                            // var providerBussiness =
                            //     context.read<ProviderBussiness>();
                            // var categoryLocal = providerBussiness.categoryLocal;
                            // var categories = providerBussiness.categories;
                            // var categoryController = TextEditingController();
                            return StreamBuilder<
                                QuerySnapshot<Map<String, dynamic>>>(
                              stream: FirebaseFirestore.instance
                                  .collection("Place")
                                  .doc(data.city.toLowerCase())
                                  .collection("SubCity")
                                  .doc(data.subCity.toLowerCase())
                                  .collection("Shop")
                                  .doc(data.numberShop)
                                  .collection("Category")
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<
                                          QuerySnapshot<Map<String, dynamic>>>
                                      snapshot) {
                                if (snapshot.hasError)
                                  return Text('Error: ${snapshot.error}');
                                switch (snapshot.connectionState) {
                                  case ConnectionState.waiting:
                                    return Center(
                                        child: CircularProgressIndicator());
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
                                            const SizedBox(height: 8),
                                            const Text(
                                                'Select a category or enter a new one:'),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 200,
                                              child: ListView.builder(
                                                itemCount:
                                                    snapshot.data!.docs.length,
                                                reverse: true,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  final category = snapshot
                                                      .data!.docs[index];
                                                  final String? name = category
                                                              .data()[
                                                          'category_name'] ??
                                                      "dd";
                                                  final int? color = category
                                                          .data()['color'] ??
                                                      "11111";

                                                  return ListTile(
                                                    tileColor: Color(color!)
                                                        .withOpacity(0.5),
                                                    title: Text(name!),
                                                    onTap: () {
                                                      final data = Provider.of<
                                                              CityModel>(
                                                          context,
                                                          listen: false);
                                                      _controller.text = name;

                                                      data.addCategory(
                                                          name.toString());

                                                      // providerBussiness
                                                      //     .addCategoryLocal(name);
                                                      // providerBussiness
                                                      //     .addCategory(name);

                                                      Navigator.pop(context);
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            TextField(
                                              controller: _controller,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Or enter a new category',
                                              ),
                                              onSubmitted: (value) {
                                                final data =
                                                    Provider.of<CityModel>(
                                                        context,
                                                        listen: false);
                                                data.addCategory(
                                                    value.toString());

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
                                            final data = Provider.of<CityModel>(
                                                context,
                                                listen: false);
                                            if (category.isNotEmpty) {
                                              data.addCategory(
                                                  category.toString());
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
                          hintText:
                              Provider.of<CityModel>(context, listen: false)
                                  .category
                                  .toString(),
                          suffixIcon: Icon(Icons.keyboard_arrow_down),
                        ),
                        child: Text(
                          Provider.of<CityModel>(context, listen: false)
                              .category
                              .toString(),
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                    ),
                  ),
                  textField(
                      controller: Provider.of<CityModel>(context, listen: true)
                          .proNameController,
                      hint: "Name",
                      type: TextInputType.name),
                  textField(
                      controller: Provider.of<CityModel>(context, listen: true)
                          .proPriceController,
                      hint: "Price",
                      type: TextInputType.number),
                  textField(
                    controller: Provider.of<CityModel>(context, listen: true)
                        .proDescriptionController,
                    hint: "Description (Optional)",
                    type: TextInputType.name,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              );
            }),
      ),
    );
  }

  Future<void> selectAndUploadImage(
      CityModel cityProvider, nameProduct, controller) async {
    final picker = ImagePicker();
    List<XFile>? pickedFiles;

    pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null && pickedFiles!.isNotEmpty) {
      cityProvider.addSelectedFiles(pickedFiles);
    }
  }

  Future<File> compressImage(File file) async {
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 800,
      minHeight: 800,
      quality: 80,
      format: CompressFormat.jpeg,
    );
    final compressedFile = File(file.path)..writeAsBytesSync(result!);
    return compressedFile;
  }

  Future<void> uploadImage(
    // XFile file,
    index,
    CityModel cityProvider,
    controller,
    pro_name,
    pro_price,
    pro_description,
  ) async {
    final storageRef = FirebaseStorage.instance.ref();
    final imageRef = storageRef
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    final compressedFile =
        await compressImage(File(cityProvider.selectedFiles[index].path));

    final uploadTask = imageRef.putFile(compressedFile);
    // final uploadTask = imageRef.putFile(File(file.path));

    final loadPercentage = cityProvider;
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      var max = 100;
      // if (progress > 0) {
      var ss = (100 / cityProvider.selectedFiles.length) * (index + 1);
      loadPercentage.progress = ss;
      print(ss);
      Timer.periodic(Duration(seconds: 1), (timer) {
        if (ss < (100 / cityProvider.selectedFiles.length) * (index + 2)) {
          if (ss <= 94) loadPercentage.progress += 1;
        } else {
          // loadPercentage.progress;
        }

        timer
            .cancel(); // Stop the timer when the progress reaches the max value
      });
      // }
    });
    final city = cityProvider.city;
    final subCity = cityProvider.subCity;
    final number = cityProvider.numberShop;
    final productId = cityProvider.productId;
    final category = cityProvider.category;
    final docRef = FirebaseFirestore.instance
        .collection("Place")
        .doc(city)
        .collection("SubCity")
        .doc(subCity)
        .collection("Shop")
        .doc(number)
        .collection("Category")
        .doc(category)
        .collection("Products")
        .doc(productId);
    try {
      await uploadTask;
      final downloadUrl = await imageRef.getDownloadURL();
      cityProvider.addDownloadUrls(downloadUrl);
      print(downloadUrl);

      try {
        // Check if the document exists
        final docSnapshot = await docRef.get();
        if (!docSnapshot.exists) {
          // Document does not exist, so create a new document
          await docRef.set({
            "productId": productId,
            "time": DateTime.now(),
            "category": category?.trim(),
            "pro_name": pro_name.trim(),
            "pro_price": pro_price.trim(),
            "pro_weight_unit": "weightUnit",
            // "lis": toImage(),
            "nameShop": "nameShop",
            "number": number,
            "thumb_nail": cityProvider.downloadUrls.first,
            'lis': cityProvider.downloadUrls.toList(),
          });
        } else {
          // Document exists, so update the thumbnail_url field
          await docRef.update({
            "productId": productId,
            "time": DateTime.now(),
            "category": category?.trim(),
            "pro_name": pro_name.trim(),
            "pro_price": pro_price.trim(),
            "pro_weight_unit": "weightUnit",
            // "lis": toImage(),
            "nameShop": "nameShop",
            "number": number,
            "thumb_nail": cityProvider.downloadUrls.first,
            'lis': cityProvider.downloadUrls.toList(),
            // 'thumbnail_url': FieldValue.arrayUnion([downloadUrl]),
          });
        }
        // print('Image upload successful. Download URL: $downloadUrl');
      } catch (error) {
        print('Image upload failed: $error');
        // Handle upload error here
      }
    } catch (e) {}
  }

  Future<void> uplo(
    CityModel cityProvider,
    controller,
    pro_name,
    pro_price,
    pro_description,
  ) async {
    var pickedFiles = cityProvider.selectedFiles;
    if (pickedFiles != null && pickedFiles!.isNotEmpty) {
      // for (final file in cityProvider.selectedFiles) {
      //   await uploadImage(file, cityProvider, controller, pro_name, pro_price,
      //       pro_description);
      // }
      for (var i = 0; i < cityProvider.selectedFiles.length; i++) {
        await uploadImage(
            i, cityProvider, controller, pro_name, pro_price, pro_description);
      }
    }
    final city = cityProvider.city;
    final subCity = cityProvider.subCity;
    final number = cityProvider.numberShop;
    final category = cityProvider.category;
    final productId = cityProvider.productId;

    // final nameProduct = cityProvider.nameProduct;
    final docRef = FirebaseFirestore.instance
        .collection("Place")
        .doc(city)
        .collection("SubCity")
        .doc(subCity)
        .collection("Shop")
        .doc(number)
        .collection("Category")
        .doc(category)
        .collection("Products")
        .doc(productId.toString());
    try {
      // Check if the document exists
      final docSnapshot = await docRef.get();
      print("object");
      if (!docSnapshot.exists) {
        // Document does not exist, so create a new document
        await docRef.update({
          "productId": productId,
          "time": DateTime.now(),
          "category": category?.trim(),
          "pro_name": pro_name.trim(),
          "pro_price": pro_price.trim(),
          "pro_weight_unit": "weightUnit",
          // "lis": toImage(),
          "nameShop": "nameShop",
          "number": number,
          "thumb_nail": cityProvider.downloadUrls.first,
          'lis': cityProvider.downloadUrls.toList(),
        });
      } else {
        // Document exists, so update the thumbnail_url field

      }
      // print('Image upload successful. Download URL: $downloadUrl');
    } catch (error) {
      print('Image upload failed: $error');
      // Handle upload error here
    }
  }

  Widget textField({dynamic hint, dynamic controller, dynamic type}) {
    String hintText = hint;
    return TextField(
      maxLines: null,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      enableInteractiveSelection: false,
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
        labelText: hintText,
        labelStyle: TextStyle(fontWeight: FontWeight.bold),
        isCollapsed: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
        prefix: SizedBox(width: 0.0, height: 48.0),
        suffix: SizedBox(width: 0.0, height: 48.0),
      ),
    );
  }
}
