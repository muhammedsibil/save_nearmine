import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_vehicle/screens/my_vehicle_screen.dart/widgets/my_vehicle_profile.dart';
import 'package:near_mine/utility/utility.dart';

import '../../../app_user/screens/user_bussiness/user_job_screen/screen/widgets/chat_job_screen.dart';
import 'widgets/my_vehicle_edit.dart';

class DriverStatus extends StatelessWidget {
  const DriverStatus({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ScreenSize.size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              SizedBox(
                height: 10,
              ),
              MyVehicleScreen(
                headName: "jj",
                jobCategory: 'Add',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

