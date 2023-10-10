import 'package:flutter/material.dart';

import '../../../../../app_vehicle/screens/vehicle_owner_screen/vehicle_owner_screen.dart';
import '../screen/user_job_screen.dart';

class UserJobListTile extends StatelessWidget {
  const UserJobListTile(
      {super.key,
      required this.userName,
      required this.userStatus,
      required this.userCategory,
      required this.number,
      required this.userId,
      required this.city,
      required this.subCity});
  final String? userName;
  final String? userStatus;
  final String? userCategory;
  final String? number;
  final String? userId;
  final String? city;
  final String? subCity;

  @override
  Widget build(BuildContext context) {
    return number != userId
        ? ListTile(
            title: Text(userName.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            subtitle: Text(
                userStatus != "available"
                    ? "not at Availabe"
                    : "at $userStatus",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.call_outlined,
                // color: Colors.blue,
              ),
            ),
            leading: const CircleAvatar(
              backgroundColor: Colors.grey,
              // backgroundImage: NetworkImage(
              //   chatListItems[i].profileURL.toString()
              // ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserJobScreen(
                    isMy: false ,
                    // final String? userName;
                    // final String? userStatus;
                    // final String? userCategory;
                    // final String? number;
                    // final String? userId;
                    ownership: "Jobs",
                    headName: userName ?? "",
                    jobCategory: userCategory ?? "",
                    userCity: city ?? "",
                    userSubCity: subCity ?? "",
                    number: userId ?? "",
                  ),
                ),
              );
            },
          )
        : const SizedBox();
  }
}
