// // ignore_for_file: prefer_typing_uninitialized_variables
// import 'dart:io';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
// import 'package:path/path.dart' as Path;

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import 'dart:io';
// import 'dart:math';
// import 'dart:math';

// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// import '../authentication/firebase_helper./firebase_helper.dart';
// import '../detail_screen/detail_screen.dart';
// import 'chat_screen_widget/bottom_bar_details_upload_widget.dart';
// import 'chat_screen_widget/bottom_bar_image_upload_widget.dart';

// var loginUser = FirebaseAuth.instance.currentUser;

// // ignore: must_be_immutable
// class ChatScreen extends StatefulWidget {
//   const ChatScreen({Key? key}) : super(key: key);

//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   Service service = Service();
//   final storeMessage = FirebaseFirestore.instance;
//   final auth = FirebaseAuth.instance;

//   // TextEditingController category = TextEditingController();
//   late final String? category;
//   TextEditingController pro_name = TextEditingController();
//   TextEditingController pro_price = TextEditingController();
//   TextEditingController cityController = TextEditingController();
//   TextEditingController subCityController = TextEditingController();
//   String city = "Manjeri";
//   String subCity = "Elankur";

//   List<String> _points = ["Sameer", "koy", "ss"];

//   final ImagePicker _picker = ImagePicker();
//   final List<XFile> _selectedFiles = [];
//   List<String> _imageList = [];
//   FirebaseStorage _storageRef = FirebaseStorage.instance;
//   List<String> _arrImageUrl = [];
//   int uploadItem = 0;
//   bool _isUploading = false;
//   bool _imageUploadCompleted = false;
//   List<String> points1 = [];
//   List<String> imageList = [];

//   List<String> toList1() {
//     _points.forEach((item) {
//       points1.add(item.toString());
//     });

//     return points1.toList();
//   }

//   List<String> toImage() {
//     _imageList.forEach((item) {
//       imageList.add(item.toString());
//     });

//     return imageList.toList();
//   }

//   getCurrentUser() {
//     final user = auth.currentUser;
//     if (user != null) {
//       loginUser = user;
//     }
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getCurrentUser();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             "Group chat",
//             style: TextStyle(fontSize: 29),
//           ),
//           automaticallyImplyLeading: false,
//           actions: [
//             IconButton(
//                 onPressed: () async {
//                   service.signOut(context);
//                   SharedPreferences pref =
//                       await SharedPreferences.getInstance();
//                   pref.remove("email");
//                 },
//                 icon: Icon(Icons.logout)),
//           ],
//           // title: Text(loginUser!.email.toString()),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: ConstrainedBox(
//             constraints:
//                 BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
//             child: SingleChildScrollView(
//               reverse: true,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   // SizedBox(
//                   //   height: 250,
//                   // ),
//                   Column(
//                     children: [
//                       Text(
//                         'Day',
//                         style: TextStyle(fontSize: 29),
//                       ),
//                       Clock(),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 250,
//                   ),
//                   // Spacer(),

//                   ShowMessage(),
//                   // const Text('Messages'),

//                   Column(
//                     children: [
//                       TextField(
//                         controller: cityController,
//                         decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.all(16),
//                             hintText: 'Enter city...'),
//                       ),
//                       TextField(
//                         controller: subCityController,
//                         decoration: const InputDecoration(
//                             contentPadding: EdgeInsets.all(16),
//                             hintText: 'Enter subcity...'),
//                       ),
//                       ElevatedButton(
//                           onPressed: () {
//                             if (cityController.text.isNotEmpty &&
//                                 subCityController.text.isNotEmpty) {
//                               subCity = subCityController.text;
//                               city = cityController.text;
//                               subCityController.clear();
//                               cityController.clear();
//                             }
//                           },
//                           child: Text("press"))
//                     ],
//                   ),
//                   SizedBox(
//                     height: 150,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//         bottomSheet: _imageUploadCompleted
//             ?
//             //   Service service = Service();
//             // final storeMessage = FirebaseFirestore.instance;
//             // final auth = FirebaseAuth.instance;
//             // TextEditingController category = TextEditingController();
//             // TextEditingController pro_name = TextEditingController();
//             // TextEditingController pro_price = TextEditingController();
//             // List<String> _points = ["Sameer", "koy", "ss"];
// // List<String> _imageList = [];
// //   FirebaseStorage _storageRef = FirebaseStorage.instance;
// //   List<String> _arrImageUrl = [];
// //   int uploadItem = 0;
// //   bool _isUploading = false;
// //   bool _imageUploadCompleted = false;
// //   List<String> points1 = [];
// //   List<String> imageList = [];
//             BottomBarDetailsUploadWidget(
//                 category: category,
//                 imageList: imageList,
//                 imageListFetched: _imageList,
//                 imageUploadCompleted: _imageUploadCompleted,
//                 pro_name: pro_name,
//                 pro_price: pro_price,
//                 toImage: toImage,
//                 storeMessage: storeMessage,
//                 uploadImagesAndDescriptions: uploadImagesAndDescriptions,
//               )
//             : BottomBarImageUploadWidget(
//                 isUploading: _isUploading,
//                 selectImage: selectImage,
//                 selectedFiles: _selectedFiles,
//                 uploadFunction: uploadFunction,
//                 uploadItem: uploadItem,
//               ));
//   }

//   void uploadFunction(List<XFile> _images) {
//     setState(() {
//       _isUploading = true;
//     });
//     for (int i = 0; i < _images.length; i++) {
//       var imageUrl = uploadFile(_images[i]);
//       _arrImageUrl.add(imageUrl.toString());
//     }
//   }

//   Future<String> uploadFile(XFile _image) async {
//     Reference reference =
//         _storageRef.ref().child("multiple_images").child(_image.name);
//     UploadTask uploadTask = reference.putFile(File(_image.path));
//     await uploadTask.whenComplete(() {
//       setState(() {
//         uploadItem++;
//         if (uploadItem == _selectedFiles.length) {
//           _isUploading = false;
//           uploadItem = 0;
//           _imageUploadCompleted = true;

//           _selectedFiles.clear();
//           print("urlllllllllllllllllllllll");
//         }

//         print(reference.getDownloadURL());
//       });
//     });
//     String url = (await reference.getDownloadURL()).toString();
//     // url = dowurl.toString();
//     print("urlllllllllllllllllllllll");

//     print(url);
//     if (url.isNotEmpty) {
//       _imageList.add(url);
//     }
//     // List<String> jj = [url.toString()];

//     // return await reference.getDownloadURL();
//     return url;
//   }

//   Future<void> selectImage() async {
//     if (_selectedFiles != null) {
//       _selectedFiles.clear();
//     }
//     try {
//       final List<XFile>? imgs = await _picker.pickMultiImage();
//       if (imgs!.isNotEmpty) {
//         _selectedFiles.addAll(imgs);
//       }
//       print("List of selected images" + imgs.length.toString());
//     } catch (e) {
//       print("sometghing wrong" + e.toString());
//     }
//     setState(() {});
//   }

//   void uploadImagesAndDescriptions() {
//     if (pro_name.text.isNotEmpty &&
//         pro_price.text.isNotEmpty &&
//         category.text.isNotEmpty) {
//       storeMessage
//           .collection("Place")
//           .doc(city)
//           .collection("SubCity")
//           .doc(subCity)
//           .collection("Shop")
//           .doc("FoodShop")
//           .collection("Category")
//           .doc("Food")
//           .collection("Product")
//           .doc()
//           .set({
//         "user": loginUser!.email.toString(),
//         "time": DateTime.now(),
//         "category": category.text.trim(),
//         "pro_name": pro_name.text.trim(),
//         "pro_price": pro_price.text.trim(),
//         "lis": toImage(),
//       });

//       category.clear();
//       pro_name.clear();
//       pro_price.clear();
//       // points1.clear();
//       // imageListFetched.clear();
//       _imageList.clear();

//       imageList.clear();
//       setState(() {
//         _imageUploadCompleted = false;
//       });
//     } else {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text("Fill in the blank"),
//             );
//           });
//     }
//   }
// }

// class ShowMessage extends StatefulWidget {
//   const ShowMessage({Key? key}) : super(key: key);

//   @override
//   State<ShowMessage> createState() => _ShowMessageState();
// }

// class _ShowMessageState extends State<ShowMessage> {
//   String city = "Wandoor";
//   String subCity = "Cherukode";
//   TextEditingController cityController = TextEditingController();
//   TextEditingController subCityController = TextEditingController();
//   bool isOpenImageList = false;

//   land() => FirebaseFirestore.instance
//       .collectionGroup("Place")
//       .where("city", isEqualTo: "Wandoor")
//       .snapshots();

//   findcity() => FirebaseFirestore.instance
//       .collection("FindCity")
//       .where("city", isEqualTo: "manjeri")
//       .snapshots();

//   // .then(
//   //   (res) => print("Successfully completed"),
//   //   onError: (e) => print("Error completing: $e"),
//   // );

//   cityMethod() => FirebaseFirestore.instance
//       .collection("Place")
//       .doc(city)
//       .collection("SubCity")
//       .doc(subCity)
//       .collection("Shop")
//       .doc("FoodShop")
//       .collection("Category")
//       .doc("Food")
//       .collection("Product")
//       .orderBy("time")
//       .snapshots();

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<QuerySnapshot>(
//       stream: findcity(),

//       // stream: FirebaseFirestore.instance.collectionGroup("Product").snapshots(),
//       // stream: FirebaseFirestore.instance
//       //     .collection("Place")
//       //     .doc(city)
//       //     .collection("SubCity")
//       //     .doc(subCity)
//       //     .collection("Shop")
//       //     .doc("FoodShop")
//       //     .collection("Category")
//       //     .doc("Food")
//       //     .collection("Product")
//       //     .orderBy("time")
//       //     .snapshots(),
//       builder: ((context, snapshot) {
//         if (!snapshot.hasData) {
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         return ListView.builder(
//           // reverse: true,
//           itemCount: snapshot.data!.docs.length,
//           shrinkWrap: true,
//           primary: false,
//           itemBuilder: (context, index) {
//             QueryDocumentSnapshot data = snapshot.data!.docs[index];
//             String city = data['city'] ?? "";
//             String cityCSity = data['subcity'] ?? "";
//             // String category = data['category'] ?? "";
//             // String name = data['pro_name'] ?? "";
//             // String price = data['pro_price'] ?? "";
//             // String userMail = data['user'] ?? "";
//             // List urlImage = data['lis'] ?? [];
//             return
//                 // return index == snapshot.data!.docs.length - 1
//                 //     ? ElevatedButton(
//                 //         onPressed: () {
//                 //           setState(() {
//                 //             isOpenImageList = !isOpenImageList;
//                 //           });
//                 //         },
//                 //         child: Column(
//                 //           children:
//                 //           urlImage.map((e) => Text(e)).toList()

//                 //         ),
//                 //       )
//                 //     :
//                 GestureDetector(
//               onTap: () {
//                 String category = data['category'] ?? "";
//                 String name = data['pro_name'] ?? "";
//                 String price = data['pro_price'] ?? "";
//                 String userMail = data['user'] ?? "";
//                 List urlImage = data['lis'] ?? [];
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                       builder: (context) => DetailScreen(
//                             category: category,
//                             name: name,
//                             price: price,
//                             urlImage: urlImage,
//                             userMail: userMail,
//                           )),
//                 );
//               },
//               child: Container(
//                 decoration: BoxDecoration(
//                     color:
//                         // color: loginUser!.email == data['user']
//                         //     ? Colors.green.withOpacity(.1):
//                         Colors.blue.withOpacity(.1),
//                     borderRadius: BorderRadius.circular(10)),
//                 margin: EdgeInsets.all(4),
//                 padding: EdgeInsets.all(16),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       city,
//                       style: TextStyle(fontSize: 60, color: Colors.red),
//                     ),
//                     // Text(
//                     //   snapshot.data!.docs[index]['pro_price'],
//                     //   style: TextStyle(fontSize: 30),
//                     // ),
//                     SizedBox(
//                       height: 4,
//                     ),
//                     Text(
//                       "name",
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     // Text(
//                     //   price,
//                     //   style: TextStyle(fontSize: 20),
//                     // ),
//                     // Text(
//                     //   userMail,
//                     //   style: TextStyle(fontSize: 20),
//                     // ),
//                     // Column(
//                     //     children: urlImage
//                     //         .map((e) => Container(
//                     //             height: 60, child: Image.network(e.toString())))
//                     //         .toList()),
//                   ],
//                 ),
//               ),
//             );
//           },
//           // gridDelegate:
//           //                       const SliverGridDelegateWithFixedCrossAxisCount(
//           //                     crossAxisCount: 3,
//           //                   ),
//         );
//       }),
//     );
//   }

//   Widget button() => ElevatedButton(
//       onPressed: () {
//         if (cityController.text.isNotEmpty &&
//             subCityController.text.isNotEmpty) {
//           subCity = subCityController.text;
//           city = cityController.text;
//           subCityController.clear();
//           cityController.clear();
//         }
//       },
//       child: Text("press"));
// }

// class Clock extends StatelessWidget {
//   const Clock({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: Stream.periodic(const Duration(seconds: 1)),
//       builder: (context, snapshot) {
//         return Center(
//           child: Text(DateTime.now().toString()),
//         );
//       },
//     );
//   }
// }
