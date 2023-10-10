import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:near_mine/home/app_bussiness/provider/provider_bussiness.dart';
import 'package:near_mine/utility/utility.dart';
import 'package:provider/provider.dart';

import 'category_horizontal.dart';

var uploadProgress;

class CategoryEditScreen extends StatefulWidget {
  const CategoryEditScreen(
      {Key? key,
      required this.snapshot,
      required this.shop,
      required this.shopName})
      : super(key: key);
  final Shop shop;
  final String shopName;
  final QuerySnapshot snapshot;

  @override
  _CategoryEditScreenState createState() => _CategoryEditScreenState();
}

class _CategoryEditScreenState extends State<CategoryEditScreen> {
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
  String? shopName;
  Future<String>? fetchShopName() async {
    try {
      final shopDoc = await FirebaseFirestore.instance
          .collection("Place")
          .doc(widget.shop.city)
          .collection("SubCity")
          .doc(widget.shop.subCity)
          .collection("Shop")
          .doc("9995498550")
          .get();
      setState(() {
        shopName = shopDoc.data()?['name'];
      });
      return shopDoc.data()?['name'];
    } catch (error) {
      print('Error fetching shop name: $error');
      return "";
    }
  }

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   fetchShopName();
  // }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchShopName();
  }

  final TextEditingController value = TextEditingController();
  @override
  Widget build(BuildContext context) {
    // shopName = widget.shopName;
    print(value);
    return Scaffold(
      // backgroundColor: Colors.grey,
      appBar: AppBar(
        title: TextField(
            controller: value,
            decoration: InputDecoration(
              hintText: shopName ?? 'Loading...',
              hintStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              border: InputBorder.none,
            ),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            onSubmitted: (value) {
              if (value.isEmpty) {
              } else {
                setState(() {
                  shopName = value;
                });
                FirebaseFirestore.instance
                    .collection("Place")
                    .doc(widget.shop.city)
                    .collection("SubCity")
                    .doc(widget.shop.subCity)
                    .collection("Shop")
                    .doc(widget.shop.businessNumber)
                    .update({'name': shopName});
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Shop name updated')),
                );
              }
            }),
        actions: [
          MediaQuery.of(context).viewInsets.bottom == 0
              ? SizedBox()
              : IconButton(
                  icon: Icon(Icons.save),
                  onPressed: () {
                    if (value.text.isEmpty) {
                    } else {
                      setState(() {
                        shopName = value.text;
                      });
                      FirebaseFirestore.instance
                          .collection("Place")
                          .doc(widget.shop.city)
                          .collection("SubCity")
                          .doc(widget.shop.subCity)
                          .collection("Shop")
                          .doc(widget.shop.businessNumber)
                          .update({'name': shopName});
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Shop name updated')),
                      );
                    }
                  })
        ],
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          height: ScreenSize.size.height,
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("Place")
                  .doc(widget.shop.city)
                  .collection("SubCity")
                  .doc(widget.shop.subCity)
                  .collection("Shop")
                  .doc(widget.shop.businessNumber)
                  .collection("Category")
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Oops, something went wrong!'));
                }

                final categoryDocs = snapshot.data?.docs ?? [];

                if (categoryDocs.isEmpty) {
                  return Center(child: Text('No categories found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final data = snapshot.data?.docs[index].data() as Map;
                    final categoryName = data['category_name'].toString();

                    return Column(
                      children: [
                        ListTile(
                          tileColor: Color(data["color"]).withOpacity(0.7),
                          title: SizedBox(
                            height: 100,
                            width: double.infinity,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60,
                                  child: Stack(
                                    children: [
                                      data["upload_progress"] == null
                                          ? Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: Colors.grey,
                                                  width: 1.0,
                                                ),
                                              ),
                                            )
                                          : ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              child: data["thumb_nail"] == null
                                                  ? const SizedBox()
                                                  : Image.network(
                                                      data["thumb_nail"]
                                                          .toString(),
                                                      width: 60,
                                                      height: 60,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          onPressed: () {
                                            _selectImage(data);
                                          },
                                          icon: const Icon(
                                            Icons.add_a_photo,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['category_name'].toString(),
                                          style: const TextStyle(fontSize: 20),
                                        ),
                                        const SizedBox(height: 4),
                                        data['upload_progress'] != null
                                            ? data['upload_progress'] == 100
                                                ? SizedBox()
                                                : const CircularProgressIndicator()
                                            : const SizedBox(),
                                        data['upload_progress'] == 100.0
                                            ? SizedBox()
                                            : Text(
                                                data['upload_progress'] == null
                                                    ? ""
                                                    : data['upload_progress']
                                                        .toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                      ],
                                    ),
                                  ),
                                ),
                                PopupMenuButton<Color>(
                                  itemBuilder: (BuildContext context) {
                                    return <PopupMenuEntry<Color>>[
                                      const PopupMenuItem<Color>(
                                        child: Text('Select a color'),
                                        enabled: false,
                                      ),
                                      const PopupMenuDivider(),
                                      for (var color in colorNames.keys)
                                        PopupMenuItem<Color>(
                                          value: color,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 24,
                                                height: 24,
                                                color: color,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Text(colorNames[color]!),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ];
                                  },
                                  onSelected: (Color selectedColor) {
                                    String? colorName =
                                        colorNames[selectedColor];
                                    if (colorName != null) {
                                      FirebaseFirestore.instance
                                          .collection("Place")
                                          .doc(widget.shop.city)
                                          .collection("SubCity")
                                          .doc(widget.shop.subCity)
                                          .collection("Shop")
                                          .doc(widget.shop.businessNumber)
                                          .collection("Category")
                                          .doc(data['category_name'])
                                          .update({
                                        'color': selectedColor.value,
                                        'color_name': colorName,
                                      });
                                    }
                                  },
                                  child: Icon(Icons.color_lens,
                                      color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    );
                  },
                );
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // _selectImage(data);
        },
      ),
    );
  }

  Future<void> _selectImage(data) async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await _uploadImage(pickedFile.path, data);
    } else {
      // User canceled the picker
    }
  }

  Future<void> _uploadImage(String imagePath, data) async {
    // Get a reference to the Firebase Storage location
    final ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');

    // Upload the file to Firebase Storage with progress percentage
    final task = ref.putFile(File(imagePath));
    final uploadProvider =
        Provider.of<ProviderBussiness>(context, listen: false);
    final doc = FirebaseFirestore.instance
        .collection("Place")
        .doc(widget.shop.city)
        .collection("SubCity")
        .doc(widget.shop.subCity)
        .collection("Shop")
        .doc(widget.shop.businessNumber)
        .collection("Category")
        .doc(data['category_name']);
    task.snapshotEvents.listen((event) async {
      uploadProgress = event.bytesTransferred / event.totalBytes;
      print(await uploadProgress);
      // uploadProvider.setUploadProgress(uploadProgress);
      await doc.update({
        'upload_progress': await uploadProgress * 100,
      });
    }, onError: (Object e) {
      print(task.snapshot);
      if (e is FirebaseException && e.code == 'canceled') {
        print('Upload canceled');
      }
    });

    // Wait for the upload task to complete
    await task;

    // Get the URL of the uploaded file
    final url = await ref.getDownloadURL();

    // Save the URL to Cloud Firestore

    await doc.update({
      'thumb_nail': url,
    });

    print(url);
  }
}



// class AppbarShopName extends StatefulWidget {
//   const AppbarShopName({super.key});

//   @override
//   State<AppbarShopName> createState() => _AppbarShopNameState();
// }

// class _AppbarShopNameState extends State<AppbarShopName> {
//   final TextEditingController value = TextEditingController();

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: FutureBuilder<String>(
//       future: fetchShopName(),
//       builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
//         if (snapshot.hasData) {
//           return AppBar(
//             title: TextField(
//               controller: value,
//               decoration: InputDecoration(
//                 hintText: snapshot.data ?? 'Loading...',
//                 hintStyle: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//                 border: InputBorder.none,
//               ),
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//               onSubmitted: (value) {
//                 setState(() {
//                   shopName = value;
//                 });
//                 FirebaseFirestore.instance
//                     .collection("Place")
//                     .doc(widget.shop.city)
//                     .collection("SubCity")
//                     .doc(widget.shop.subCity)
//                     .collection("Shop")
//                     .doc(widget.shop.businessNumber)
//                     .update({'name': shopName});
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Shop name updated')),
//                 );
//               },
//             ),
//             actions: [
//               IconButton(
//                 icon: Icon(Icons.save),
//                 onPressed: () {
//                   // Save the updated shop name to the database
//                   setState(() {
//                     shopName = value.text;
//                   });
//                   FirebaseFirestore.instance
//                       .collection("Place")
//                       .doc(widget.shop.city)
//                       .collection("SubCity")
//                       .doc(widget.shop.subCity)
//                       .collection("Shop")
//                       .doc(widget.shop.businessNumber)
//                       .update({'name': shopName});
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(content: Text('Shop name updated')),
//                   );
//                 },
//               ),
//             ],
//           );
//         } else if (snapshot.hasError) {
//           return Center(child: Text('Error fetching shop name: ${snapshot.error}'));
//         } else {
//           return AppBar(
//             title: Text('Loading...'),
//             centerTitle: true,
//           );
//         }
//       },
//     )
//   );
// }

// }