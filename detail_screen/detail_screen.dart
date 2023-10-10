import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  String category;
  String name;
  String price;
  String userMail;
  List urlImage;
   DetailScreen(
      {Key? key,
     required this.category,
      required this.name,
      required this.price,
      required this.urlImage,
      required this.userMail})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(name)));
    
  }
}
