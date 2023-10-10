import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../detail_screen/detail_screen.dart';
import '../../find_city/provider/data.dart';

class Shops extends StatefulWidget {
  const Shops({Key? key}) : super(key: key);

  @override
  State<Shops> createState() => _ShopsState();
}

class _ShopsState extends State<Shops> {
  String city = "Wandoor";
  String subCity = "Cherukode";
  TextEditingController cityController = TextEditingController();
  TextEditingController subCityController = TextEditingController();
  bool isOpenImageList = false;

  land() => FirebaseFirestore.instance
      .collectionGroup("Place")
      .where("city", isEqualTo: "Wandoor")
      .snapshots();

  findcity(city, subCity) => FirebaseFirestore.instance
      .collection("FindCity")
      .where("city", isEqualTo: "manjeri")
      .snapshots();

  // .then(
  //   (res) => print("Successfully completed"),
  //   onError: (e) => print("Error completing: $e"),
  // );

  cityMethod(city, subCity) => FirebaseFirestore.instance
      .collection("Place")
      .doc(city)
      .collection("SubCity")
      .doc(subCity)
      .collection("Shop")
      .doc("FoodShop")
      .collection("Category")
      .doc("Food")
      .collection("Product")
      .orderBy("time")
      .snapshots();

  @override
  Widget build(BuildContext context) {
    String city = context.watch<CityModel>().city;
    String subCity = context.watch<CityModel>().subCity;

    return StreamBuilder<QuerySnapshot>(
      stream: cityMethod(city, subCity),

      // stream: FirebaseFirestore.instance.collectionGroup("Product").snapshots(),
      // stream: FirebaseFirestore.instance
      //     .collection("Place")
      //     .doc(city)
      //     .collection("SubCity")
      //     .doc(subCity)
      //     .collection("Shop")
      //     .doc("FoodShop")
      //     .collection("Category")
      //     .doc("Food")
      //     .collection("Product")
      //     .orderBy("time")
      //     .snapshots(),
      builder: ((context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        return ListView.builder(
          // reverse: true,
          itemCount: snapshot.data!.docs.length,
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot data = snapshot.data!.docs[index];
            // String city = data['city'] ?? "";
            // String cityCSity = data['subcity'] ?? "";
            String category = data['category'] ?? "";
            String name = data['pro_name'] ?? "";
            String price = data['pro_price'] ?? "";
            String userMail = data['user'] ?? "";
            List urlImage = data['lis'] ?? [];
            return
                // return index == snapshot.data!.docs.length - 1
                //     ? ElevatedButton(
                //         onPressed: () {
                //           setState(() {
                //             isOpenImageList = !isOpenImageList;
                //           });
                //         },
                //         child: Column(
                //           children:
                //           urlImage.map((e) => Text(e)).toList()

                //         ),
                //       )
                //     :
                GestureDetector(
              onTap: () {
                String category = data['category'] ?? "";
                String name = data['pro_name'] ?? "";
                String price = data['pro_price'] ?? "";
                String userMail = data['user'] ?? "";
                List urlImage = data['lis'] ?? [];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DetailScreen(
                            category: category,
                            name: name,
                            price: price,
                            urlImage: urlImage,
                            userMail: userMail,
                          )),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                    color:
                        // color: loginUser!.email == data['user']
                        //     ? Colors.green.withOpacity(.1):
                        Colors.blue.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Image.network(
                        urlImage[0]
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(fontSize: 60, color: Colors.red),
                    ),
                    // Text(
                    //   snapshot.data!.docs[index]['pro_price'],
                    //   style: TextStyle(fontSize: 30),
                    // ),
                    SizedBox(
                      height: 4,
                    ),
                    Text(
                      "name",
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      price,
                      style: TextStyle(fontSize: 20),
                    ),
                    Text(
                      userMail,
                      style: TextStyle(fontSize: 20),
                    ),

                    Column(
                      children: urlImage
                          .map((e) => Container(
                              height: 60, child: Image.network(e.toString())))
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
          // gridDelegate:
          //                       const SliverGridDelegateWithFixedCrossAxisCount(
          //                     crossAxisCount: 3,
          //                   ),
        );
      }),
    );
  }

  Widget button() => ElevatedButton(
      onPressed: () {
        if (cityController.text.isNotEmpty &&
            subCityController.text.isNotEmpty) {
          subCity = subCityController.text;
          city = cityController.text;
          subCityController.clear();
          cityController.clear();
        }
      },
      child: Text("press"));
}
