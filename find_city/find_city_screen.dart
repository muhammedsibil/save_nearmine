import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:near_mine/data_model/user.dart';
import 'package:near_mine/find_city/provider/data.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../detail_screen/detail_screen.dart';
import '../home/home_screen.dart';
import '../main.dart';
import '../widgets/bottom_widget.dart';

class FindCityScreen extends StatefulWidget {
  const FindCityScreen({Key? key}) : super(key: key);

  @override
  State<FindCityScreen> createState() => _FindCityScreenState();
}

class _FindCityScreenState extends State<FindCityScreen> {
  var city;
  var subCity;
  TextEditingController cityController = TextEditingController();
  TextEditingController subCityController = TextEditingController();
  bool isOpenImageList = false;

  String selectedValue = "";

  findcity() => FirebaseFirestore.instance.collection("FindCity").snapshots();

  cityMethod() => FirebaseFirestore.instance
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

  addshop(city, subCity, numberShop, nameShop, ownership) {
    if (city.isNotEmpty &&
        subCity.isNotEmpty &&
        numberShop.isNotEmpty &&
        ownership.isNotEmpty) {
      print("success upload shop");
      FirebaseFirestore.instance
          .collection("Place")
          .doc(city)
          .collection("SubCity")
          .doc(subCity)
          .collection(ownership)
          .doc(numberShop)
          .set({
        "name": nameShop,
        "number": numberShop,
        "city": city,
        "sub_city": subCity,
        "ownership": ownership,
      });
    } else {
      print("false add shop");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("koooooi");
  }

  // var _myString;
  // void _loadData() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _myString = prefs.getString('my_string_key') ?? '';
  //   });
  // }
  var number;
  var ownership;

  @override
  Widget build(BuildContext context) {
    city = context.watch<CityModel>().city;
    subCity = context.watch<CityModel>().subCity;
    number = context.watch<CityModel>().numberShop;
    var nameShop = context.watch<CityModel>().nameShop;
    ownership = context.watch<CityModel>().ownership;

    // addshop();
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
            child: searchBox(number, nameShop, ownership)),
        bottomSheet: GestureDetector(
          onTap: () {
            void _saveData() async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('number', number);
              await prefs.setString('city', city);
              await prefs.setString('subCity', subCity);
              await prefs.setString('ownership', ownership);
              
              print(prefs.getString(number));
              print("getString");
            }

            print("heeeeeee");
            selectedValue.isNotEmpty
                ? Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          HomePage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        var begin = Offset(1.0, 0.0);
                        var end = Offset.zero;
                        var curve = Curves.ease;

                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));

                        return SlideTransition(
                          position: animation.drive(tween),
                          child: child,
                        );
                      },
                    ),
                  )
                // Navigator.pushReplacement(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomePage()),

                // Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => HomePage()),
                //   )
                : null;
          },
          child: Container(
            alignment: Alignment.center,
            height: 80,
            color: Color.fromRGBO(0, 0, 0, 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                    child: Container(
                        alignment: Alignment.center,
                        child: selectedValue.isNotEmpty
                            ? Text(
                                selectedValue,
                                style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              )
                            : SizedBox())),
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Continue",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget searchBox(numberShop, nameShop, ownership) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 10,
          ),
          textField(),
          subCityList(numberShop, nameShop, ownership),
        ],
      ),
    );
  }

  Widget textField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: TextField(
        controller: subCityController,
// readOnly: true,
        onTap: () {
          print("hellooooooooooooooooo");
          setState(() {
            // isSearchTap = !isSearchTap;
          });
        },
        onChanged: (value) {
          subCity = value;
          print(subCity);

          // if(city==""){
          //   setState(() {

          // });
          // }

          setState(() {});
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter a search term',
        ),
      ),
    );
  }

  Widget subCityList(numberShop, nameShop, ownership) {
    return StreamBuilder<QuerySnapshot>(
      stream: findcity(),
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
          physics: const NeverScrollableScrollPhysics(),

          primary: false,
          itemBuilder: (context, index) {
            QueryDocumentSnapshot data = snapshot.data!.docs[index];
            String city = data['city'] ?? "";
            String subCity = data['subcity'] ?? "";
            print(subCity);
            return GestureDetector(
              onTap: () {
                void _saveData() async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.setString('number', number);
                  await prefs.setString('city', city);
                  await prefs.setString('subCity', subCity);
                  await prefs.setString('ownership', ownership);
                  print(prefs.getString(number));
                  print("getString");
                }

                setState(() {
                  selectedValue = subCity;
                });
                context.read<CityModel>().addCity(city, subCity);
                addshop(city, subCity, numberShop, nameShop, ownership);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeScreen()),
                // );
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
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          subCity,
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          city,
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ],
                    ),
                    Spacer(),
                    subCity == selectedValue ? Icon(Icons.done) : SizedBox(),
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

  // Widget bottomSheet (){
  //   return
  //    Container(
  //     alignment: Alignment.center,
  //     height: 80,
  //     color: Colors.black,
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceAround,
  //       children: [
  //         Expanded(
  //             flex: 2,
  //             child: Container(
  //                 alignment: Alignment.center,
  //                 child: Text(
  //                   selectedValue,
  //                   style: TextStyle(
  //                       color: Colors.grey, fontWeight: FontWeight.normal),
  //                 ))),
  //         SizedBox(width: 10),
  //         Expanded(
  //             child: GestureDetector(
  //               onTap: (){
  //                 Navigator.push(
  //             context,
  //             MaterialPageRoute(builder: (context) => HomeScreen()),
  //           );
  //               },
  //                 child: Text(
  //           "Continue",
  //           style:
  //               TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
  //         ))),
  //       ],
  //     ),
  //   )
  //   ;
  // }
}
