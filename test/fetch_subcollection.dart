import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../find_city/provider/data.dart';

class FetchSubcollections extends StatefulWidget {
  const FetchSubcollections({Key? key}) : super(key: key);

  @override
  State<FetchSubcollections> createState() => _FetchSubcollectionsState();
}

class _FetchSubcollectionsState extends State<FetchSubcollections> {
  String city = "";

  String subCity = "";

  String shopName = "shop name";
  String number = "9995498550";
  var listt;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final _store = Provider.of<CityModel>(context, listen: false);
    city = _store.city;
    subCity =_store.subCity;
   
    getLists();
  }

  List<String> categoryList = [];

  Future<List> getLists() async {
    CollectionReference col_ref = FirebaseFirestore.instance
        .collection("Place")
        .doc(city)
        .collection("SubCity")
        .doc(subCity)
        .collection("Shop")
        .doc("9995498550")
        .collection("Category");
    QuerySnapshot docSnap = await col_ref.get();
    docSnap.docs.forEach((elements) {
      categoryList.add(elements.id);
      
      if(categoryList.length == docSnap.docs.length)
      print("heloooooojjj");
      setState(() {});
    });
    return categoryList;
  }

  @override
  Widget build(BuildContext context) {
   
    if (categoryList.isEmpty) {
      return Scaffold(body: CircularProgressIndicator());
    }
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: categoryList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 100,
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("Place")
                          .doc(city)
                          .collection("SubCity")
                          .doc(subCity)
                          .collection("Shop")
                          .doc("9995498550")
                          .collection("Category")
                          .doc(categoryList[index])
                          .collection("Product")
                          .limit(3)
                          .orderBy("time")
                          .get(),
                      builder:
                          (BuildContext context, AsyncSnapshot<dynamic> snap) {
                        if (!snap.hasData) {
                          return CircularProgressIndicator();
                        }
                        return ListTile(
                          title: Text(categoryList[index]),
                          subtitle: ListView.builder(
                            itemCount: snap.data!.docs.length,
                            itemBuilder: (BuildContext context, int index) {
                              QueryDocumentSnapshot data =
                                  snap.data!.docs[index];

                              var pro = data['time'] ?? "";
                              var cat = data['pro_name'] ?? "";
                              var category = data['category'] ?? "";

                              print(pro);
                              return ListTile(
                                title: Container(
                                  color: Colors.green,
                                  child: Text(pro.toString()),
                                ),
                                subtitle: Container(
                                  color: Colors.green,
                                  child: Column(
                                    children: [
                                      Text(cat.toString()),
                                      Text(category.toString()),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          
          ],
        ),
      ),
    );
  }
}
