import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../find_city/provider/data.dart';
import 'vehicle_list_tile.dart';

class VehicleList extends StatefulWidget {
  const VehicleList({super.key});

  @override
  State<VehicleList> createState() => _VehicleListState();
}

class _VehicleListState extends State<VehicleList> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: BuildCategory(),
      ),
    );
  }
}

class BuildCategory extends StatefulWidget {
  const BuildCategory({super.key});

  @override
  State<BuildCategory> createState() => _BuildCategoryState();
}

class _BuildCategoryState extends State<BuildCategory> {
  var categoriesLength = 5;
  @override
  Widget build(BuildContext context) {
    final store = Provider.of<CityModel>(context, listen: false);
    var _city = store.city;
    var _subCity = store.subCity;
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Place")
          .doc(_city)
          .collection("SubCity")
          .doc(_subCity)
          .collection("vehicles")
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }

        Map<String, List<Map<String, dynamic>>> categories = {};

        snapshot.data?.docs.forEach((document) {
          var data = document.data() as Map;
          String name = data["name_driver"] ?? "";
          String category = data["vehicle_type"] ?? "";
          bool status = data["status_range"] ?? true;
          if (!categories.containsKey(category)) {
            categories[category] = [];
          }
          categories[category]
              ?.add({"name": name, "status": status, "category": category});
        });
        print(categories);
        return Column(
          children: [
            const SizedBox(
              height: 30,
            ),
            if (categories.containsKey("aouto rikshaw"))
              category(
                categories,
                "aouto rikshaw",
              ),
            const Divider(),
            const SizedBox(
              height: 30,
            ),
            if (categories.containsKey("lorry")) category(categories, "lorry"),
            const Divider(),
          ],
        );
      },
    );
  }

  Widget category(dynamic categories, String vehicle) {
    var totalVehicle =
        categories[vehicle]!.take(categoriesLength).toList().length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Text(
                vehicle.toUpperCase(),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              Spacer(),
              ElevatedButton(
                  onPressed: () async {
                    var vehicles = FirebaseFirestore.instance
                        .collection("Place")
                        .doc("manjeri")
                        .collection("SubCity")
                        .doc("elankur")
                        .collection("VehicleRequest")
                        .doc("7907156601");
                    vehicles.set({
                      "requested_status": true,
                      "requested_user": "Shibia",
                      'requested_at': FieldValue.serverTimestamp(),
                    });

                    // var vehicles = FirebaseFirestore.instance
                    //     .collection("Place")
                    //     .doc("manjeri")
                    //     .collection("SubCity")
                    //     .doc("elankur")
                    //     .collection("vehicles")
                    //     .where("status_driver", isEqualTo: "🚗 Vehicle Stand")
                    //     .where("status_range", isEqualTo: true)
                    //     .limit(2);

                    // var snapshot = await vehicles.get();
                    // if (snapshot.docs.isNotEmpty) {
                    //   for (var doc in snapshot.docs) {
                    //     var request = FirebaseFirestore.instance
                    //         .collection("Place")
                    //         .doc("manjeri")
                    //         .collection("SubCity")
                    //         .doc("elankur")
                    //         .collection("VehicleRequest")
                    //         .doc(doc.id);
                    //     if (!doc.exists) {
                    //       await request.set({
                    //         'field1': 'value1',
                    //         'field2': 'value2',
                    //       });
                    //     } else {
                    //       await request.update({
                    //         "requested": true,
                    //         "requested_user": "Shibia",
                    //         'requested_at': FieldValue.serverTimestamp(),
                    //       });
                    //     }
                    //   }
                    // }
                  },
                  child: Text("Request"))
            ],
          ),
        ),
        ...categories[vehicle]!.take(categoriesLength).map((vehicle) {
          print(vehicle["name"]);
          print(vehicle["status"]);
          print("name y");

          return VehicleListTile(
            vehicleName: vehicle["name"],
            vehicleStatus: vehicle["status"],
            vehicleCategory: vehicle["category"],
          );
        }),
        SizedBox(
          height: 19,
        ),
        if (!(totalVehicle <= 4))
          TextButton(
            child: Center(
              child: Text(
                categoriesLength > totalVehicle ? "See less" : "See more",
                style: TextStyle(color: Colors.black.withOpacity(0.5)),
              ),
            ),
            onPressed: () {
              setState(() {
                categoriesLength > totalVehicle
                    ? categoriesLength -= 4
                    : categoriesLength += 4;
              });
            },
          )
      ],
    );
  }
}
