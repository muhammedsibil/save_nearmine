import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_vehicle/screens/my_vehicle_screen.dart/widgets/my_vehicle_request.dart';
import 'package:near_mine/utility/utility.dart';

import '../../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';

class UserVehicleRequests extends StatefulWidget {
  const UserVehicleRequests({super.key});

  @override
  _UserVehicleRequestsState createState() => _UserVehicleRequestsState();
}

class _UserVehicleRequestsState extends State<UserVehicleRequests>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("object");

    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Place")
            .doc("manjeri")
            .collection("SubCity")
            .doc("elankur")
            .collection("vehicles")
            .where("vehicle_id", isEqualTo: "7907156601")
            .limit(1)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          QueryDocumentSnapshot<Object?>? datas = snapshot.data!.docs[0];
          Map dataStatusRange = datas.data() as Map;
          var s = dataStatusRange["status_driver"];
          final bool driverStatus = "🚗 Vehicle Stand" == s;
          return StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Place")
                .doc("manjeri")
                .collection("SubCity")
                .doc("elankur")
                .collection("VehicleRequest")
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return !driverStatus
                  ? const SizedBox()
                  : SizedBox(
                      height: 479,
                      child: ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            QueryDocumentSnapshot<Object?> data =
                                snapshot.data!.docs[index];
                            Map dataMap = data.data() as Map;
                            var user = dataMap["requested_user"];
                            var requested = dataMap["requested_status"] ?? true;
                            // userId[0]["stand_status"];
                            print(requested);

                            return Center(
                              child: AnimatedBuilder(
                                animation: _animationController,
                                builder: (BuildContext context, Widget? child) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(10),
                                        // height: 150.0,
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.grey.withOpacity(
                                                _animationController.value),
                                            width: 2.0,
                                          ),
                                        ),
                                        child: MyVehicleRequest(
                                            requested: requested, user: user)),
                                  );
                                },
                              ),
                            );
                          }),
                    );
            },
          );
        });
  }
}
