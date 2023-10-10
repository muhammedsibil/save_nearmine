// ignore_for_file: prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as Path;
import 'package:image/image.dart' as img;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../authentication/firebase_helper./firebase_helper.dart';
import '../../../../chat_screen/chat_screen_widget/bottom_bar_details_upload_widget.dart';
import '../../../../chat_screen/chat_screen_widget/bottom_bar_image_upload_widget.dart';
import '../../../../detail_screen/detail_screen.dart';
import '../../../../find_city/provider/data.dart';
import '../../../../utility/utility.dart';
import '../../provider/provider_bussiness.dart';
import 'widgets/product_description.dart';

var loginUser = FirebaseAuth.instance.currentUser;
List<String> _arrImageUrl = [];
String? _thumbNailUrl;
int uploadItem = 0;
var uploadProgress;
double? percentage;

// ignore: must_be_immutable
class ProductUpload extends StatefulWidget {
  const ProductUpload({Key? key, this.categoryPass}) : super(key: key);
  final String? categoryPass;
  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
    final store = Provider.of<CityModel>(context, listen: false);
    // _city = store.city;
    // _subCity = store.subCity;
    // getLists();
  }

  final List<XFile> _selectedFiles = [];
  bool _isUploading = false;
  String weightUnit = "";

  Service service = Service();
  final storeMessage = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

// TextEditingController category = TextEditingController();
  String? category;
  TextEditingController pro_name = TextEditingController();
  TextEditingController pro_price = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController subCityController = TextEditingController();
  String city = "manjeri";
  String subCity = "elankur";
  String number = "9995498550";
  String nameShop = "name shop";

  List<String> _points = ["Sameer", "koy", "ss"];

  final ImagePicker _picker = ImagePicker();
  List<String> _imageList = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  bool _imageUploadCompleted = false;
  List<String> imageList = [];

  List<String> toImage() {
    _imageList.forEach((item) {
      imageList.add(item.toString());
    });

    return imageList.toList();
  }

  getCurrentUser() {
    final user = auth.currentUser;
    if (user != null) {
      loginUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Product Upload",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () async {
                service.signOut(context);
                SharedPreferences pref = await SharedPreferences.getInstance();
                pref.remove("email");
              },
              icon: Icon(Icons.logout)),
        ],
        // title: Text(loginUser!.email.toString()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ConstrainedBox(
          constraints:
              BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
          child: SingleChildScrollView(
            reverse: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  children: [
                    addImages(
                      100.0,
                      60.0,
                    ),
                    Provider.of<CityModel>(context, listen: false)
                            .isUploading
                        ? Stack(
                            alignment: Alignment.center,
                            children: [
                              CircularProgressIndicator(
                                backgroundColor: Colors.black,
                                color: Colors.green,
                                value: Provider.of<CityModel>(context,
                                            listen: false)
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
                    // Text((Provider.of<ProviderBussiness>(context, listen: false)
                    //             .progress
                    //             .toDouble() -
                    //         16)
                    //     .toString()),
                    ProductDescription(
                      categoryPass: widget.categoryPass,
                      category: category,
                      imageList: imageList,
                      imageListFetched: _imageList,
                      imageUploadCompleted: _imageUploadCompleted,
                      pro_name: pro_name,
                      pro_price: pro_price,
                      toImage: toImage,
                      storeMessage: storeMessage,
                      uploadImagesAndDescriptions: uploadImagesAndDescriptions,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          var data =
                              Provider.of<CityModel>(context, listen: false);
                          var dataC = Provider.of<CityModel>(context,
                              listen: false);
                          // weightUnit =
                          //     context.read<ProviderBussiness>().weightUnit;
                          city = data.city;
                          subCity = data.subCity;
                          number = data.numberShop;
                          nameShop = data.nameShop;

                          // category = dataC.uploadCategory;

                          dataC.isUploading = true;

                          uploadFunction(
                                  _selectedFiles, uploadImagesAndDescriptions)
                              .then((value) {
                            print("uploadState.isUploading = true");
                            dataC.isUploading = false;
                          }).catchError((error) {
                            print("uploadState.isUploading = false");

                            dataC.isUploading = false;
                          });
                          // Navigator.popUntil(
                          //     context, ModalRoute.withName('/home'));
                        },
                        child: SizedBox()),
                    _isUploading
                        ? SizedBox(
                            height: 70,
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                Text("uploading: " + uploadItem.toString()),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  addImages(
    double height,
    width,
  ) {
    // var f = snapshot.data?.docs.first;
    // var s = f!.data() as Map;
    // print(s);

    var size = MediaQuery.of(context).size.width;

    if (_selectedFiles.isEmpty) {
      return GestureDetector(
          onTap: () {
            selectImage();
          },
          child: Container(
              height: size - height,
              width: size - width,
              color: Colors.grey.shade100,
              child: Icon(Icons.add)));
    }
    return Column(
      children: [
        Container(
          height: size - height,
          width: size - width,
          color: Colors.grey.withOpacity(0.3),
          child: Image.file(
            File(
              _selectedFiles.first.path,
            ),
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 22),
          height: 60,
          width: double.infinity,
          child: Stack(
            children: [
              ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  for (var j = 1; j < _selectedFiles.length; j++)
                    SizedBox(
                      height: 60,
                      width: 60,
                      child: Image.file(
                        File(_selectedFiles[j].path),
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  height: 60,
                  width: 60,
                  child: IconButton(
                    icon: Icon(
                      Icons.add_a_photo,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      selectImage();
                    },
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Future<void> uploadFunction(
      List<XFile> images, uploadImagesAndDescriptions) async {
    _isUploading = true;

    // if (mounted) {
    //   setState(() {
    //     _isUploading = true;
    //   });
    // }
    for (int i = 0; i < images.length; i++) {
      var imageUrl = await uploadFile(
          images[i], uploadImagesAndDescriptions, i == 0, i, images.length);
      _arrImageUrl.add(imageUrl.toString());
    }
  }

  Future<String> uploadFile(XFile image, uploadImagesAndDescriptions,
      bool isThumbNail, int i, int totalImages) async {
    Reference reference =
        _storageRef.ref().child("multiple_images").child(image.name);
    UploadTask uploadTask = reference.putFile(File(image.path));

    final loadPercentage =
        Provider.of<CityModel>(context, listen: false);
    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      double progress = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
      var max = 100;

      if (progress > 0) {
        var ss = (100 / totalImages) * (i + 1);
        loadPercentage.progress = ss;
        Timer.periodic(Duration(seconds: 1), (timer) {
          if (ss < (100 / totalImages) * (i + 2)) {
            if (ss <= 94) loadPercentage.progress += 1;
          } else {
            // loadPercentage.progress;
          }

          if (ss >= max) {
            timer
                .cancel(); // Stop the timer when the progress reaches the max value
          }
        });
      }
    });

    await uploadTask.whenComplete(() {
      uploadItem++;

      // if (mounted) {
      //   setState(() {
      //     uploadItem++;
      //   });
      // }
    });
    // Reference reference =
    //     _storageRef.ref().child("multiple_images").child(image.name);
    // UploadTask uploadTask = reference.putFile(File(image.path));
    // uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
    //   percentage = (snapshot.bytesTransferred / snapshot.totalBytes) * 100;
    //   print('Upload percentage: $percentage%');
    // });
    String url = (await reference.getDownloadURL()).toString();

    if (url.isNotEmpty) {
      _imageList.add(url);
      if (isThumbNail) {
        // Create thumbnail image
        final bytes = await File(image.path).readAsBytes();
        final thumbnail = img.copyResize(img.decodeImage(bytes)!, width: 200);

        // Upload thumbnail to Firestore
        final thumbNailReference =
            _storageRef.ref().child("thumbnails").child(image.name);
        final thumbNailTask =
            thumbNailReference.putData(img.encodeJpg(thumbnail));
        final thumbNailUrl = await thumbNailTask
            .then((taskSnapshot) => taskSnapshot.ref.getDownloadURL());

        // Set thumb_nail field in Firestore document
        if (thumbNailUrl.isNotEmpty) {
          _thumbNailUrl = thumbNailUrl;

          // if (mounted) {

          //   setState(() {
          //     _thumbNailUrl = thumbNailUrl;
          //   });
          // }
        }
      }

      if (uploadItem == _selectedFiles.length) {
        uploadItem = 0;
        uploadImagesAndDescriptions();
        _isUploading = false;
        _selectedFiles.clear();
        // if (mounted) {
        //   setState(() {
        //     uploadItem = 0;
        //     uploadImagesAndDescriptions();
        //     _isUploading = false;
        //     _selectedFiles.clear();
        //   });
        // }
      }
    }

    return url;
  }

  Future<void> selectImage() async {
    // if (_selectedFiles != null) {
    //   _selectedFiles.clear();
    // }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of selected images" + imgs.length.toString());
    } catch (e) {
      print("sometghing wrong" + e.toString());
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> uploadImagesAndDescriptions() async {
    if (pro_name.text.isNotEmpty &&
        pro_price.text.isNotEmpty &&
        category!.isNotEmpty) {
      var categoryC = storeMessage
          .collection("Place")
          .doc(city.toLowerCase())
          .collection("SubCity")
          .doc(subCity.toLowerCase())
          .collection("Shop")
          .doc(number)
          .collection("Category");
      DocumentSnapshot categoryDoc = await categoryC.doc(category).get();
      String? thumb_nail;
      if (categoryDoc.exists && categoryDoc.data() != null) {
        var data = categoryDoc.data()! as Map;
        thumb_nail = data["thumb_nail"] ?? "";
      } else {
        thumb_nail = null;
      }
      thumb_nail == null
          ? categoryC.doc(category?.trim().toLowerCase()).set({
              "category_name": category?.trim(),
              "priority": "1",
              'upload_progress': null,
              'color': 4292984551,
              'color_name': "",
              'thumb_nail': thumb_nail,
            })
          : null;

      var productC =
          categoryC.doc(category?.trim().toLowerCase()).collection("Product");
      String productId = productC.doc().id;

      if (_thumbNailUrl != null) {
        await productC.doc(productId).set({
          // "user": loginUser!.email.toString(),
          "productId": productId,
          "time": DateTime.now(),
          "category": category?.trim(),
          "pro_name": pro_name.text.trim(),
          "pro_price": pro_price.text.trim(),
          "pro_weight_unit": weightUnit,
          "lis": toImage(),
          "nameShop": nameShop,
          "number": number,
          "thumb_nail": _thumbNailUrl,
          // 'upload_progress': uploadProgress * 100,
        }).whenComplete(() {
          // category!.clear();
          pro_name.clear();
          pro_price.clear();
          // points1.clear();
          // imageListFetched.clear();
          _imageList.clear();
          imageList.clear();
        });
      }
      _imageUploadCompleted = false;

      // if (mounted) {
      //   setState(() {
      //     _imageUploadCompleted = false;
      //   });
      // }
    } else {
      print(" Fill in the blank");
      // showDialog(
      //     context: context,
      //     builder: (context) {
      //       return AlertDialog(
      //         title: Text('Error'),
      //         content: Text("Fill in the blank"),
      //       );
      //     });
    }
  }
}
