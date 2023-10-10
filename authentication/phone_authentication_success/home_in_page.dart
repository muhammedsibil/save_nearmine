import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../find_city/provider/data.dart';

class HomeInPage extends StatefulWidget {
  const HomeInPage({Key? key}) : super(key: key);

  @override
  State<HomeInPage> createState() => _HomeInPageState();
}

class _HomeInPageState extends State<HomeInPage> {
 

  createshop(city, subCity) => FirebaseFirestore.instance
      .collection("Place")
      .doc(city)
      .collection("SubCity")
      .doc(subCity)
      .collection("Shop")

      // .where("city", isEqualTo: "manjeri")
     .get();

    addshop(city,subCity,numberShop,nameShop){ 
           FirebaseFirestore.instance.collection("Place")
          .doc(city)
          .collection("SubCity")
          .doc(subCity)
          .collection("Shop")
          .doc(numberShop)
          .set({
            "name":nameShop,
            "number":numberShop,
        // "user": loginUser!.email.toString(),
        // "time": DateTime.now(),
        // "category": category.text.trim(),
        // "pro_name": pro_name.text.trim(),
        // "pro_price": pro_price.text.trim(),
        // "lis": toImage(),
      });}
  @override
  Widget build(BuildContext context) {
    String city = context.watch<CityModel>().city;
    String subCity = context.watch<CityModel>().subCity;
    String nameShop = context.watch<CityModel>().nameShop;
    String numberShop = context.watch<CityModel>().numberShop;

    return Scaffold(
      body: Column(
        children:[
          Container(
            child: Text("haii"),
          ),
           FutureBuilder<QuerySnapshot>(
          future: addshop(city, subCity, numberShop,nameShop),
          builder: ((context, snapshot) {
            // return uploadProduct();
            if (!snapshot.hasData) {
              return  CircularProgressIndicator();
            }
            return Container(child: Text("Welcome to home"));
            // categoryName(snapshot);
          }),
        ),],
      ),
    );
  }
}
