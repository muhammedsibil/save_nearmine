import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_user/screens/user_bussiness/user_job_screen/widgets/user_job_list_tile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../../find_city/provider/data.dart';
import '../screen/user_job_screen.dart';

class UserJobList extends StatefulWidget {
  const UserJobList({super.key});

  @override
  State<UserJobList> createState() => _UserJobListState();
}

class _UserJobListState extends State<UserJobList> {
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
  var categoriesLength = 3;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNumber();
  }

  String? number;
  getNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      number = prefs.getString('stringValue');
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<CityModel>(context, listen: false);
    var city = store.city;
    var subCity = store.subCity;
    print(number);
    print("number");
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: FirebaseFirestore.instance
          .collection("Place")
          .doc(city)
          .collection("SubCity")
          .doc(subCity)
          .collection("Jobs")
          .snapshots(),
      builder: (context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        Map<String, List<Map<dynamic, dynamic>>> categories = {};
        Map? data;
        bool isMe = true;

        snapshot.data?.docs.forEach((document) {
          data = document.data() as Map;
          String name = data!["user_name"] ?? "";
          String category = data!["user_type"] ?? "";
          String status = data!["user_status"] ?? "";
          String userId = data!["user_id"] ?? "";
          String city = data!["user_city"] ?? "";
          String subCity = data!["user_sub_city"] ?? "";
          String thumbNail = data!["thumb_nail"] ?? "";
          // isMe = (data!["user_id"] == number);
          if (!categories.containsKey(category)) {
            categories[category] = [];
          }
          categories[category]?.add({
            "name": name,
            "status": status,
            "category": category,
            "user_id": userId,
            "city": city,
            "sub_city": subCity,
            "thub_nail": thumbNail
          });
        });
        print("niiiiiiiiiiiiiiiiiiiiiiiiiii");
        print(data!["user_id"]);
        return number!.isEmpty
            ? const SizedBox()
            : Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  
                  // !('uid' == number)
                  //     ? Container(
                  //         // padding: const EdgeInsets.all(8.0),
                  //         width: double.infinity,
                  //         alignment: Alignment.center,
                  //         // height: 60,

                  //         color: Colors.black87,
                  //         child: ListTile(
                  //           onTap: () {
                  //             Navigator.push(
                  //               context,
                  //               MaterialPageRoute(
                  //                   builder: (context) => UserJobScreen(
                  //                         isMy: true,
                  //                         ownership: "User",
                  //                         headName: "your work",
                  //                         jobCategory: "Add",
                  //                         userCity: city,
                  //                         userSubCity: subCity,
                  //                         number: number ?? "",
                  //                       )),
                  //             );
                  //           },
                  //           leading: Padding(
                  //             padding: const EdgeInsets.all(8.0),
                  //             child: Icon(
                  //               Icons.add_circle,
                  //               color: Colors.white70,
                  //             ),
                  //           ),
                  //           title: const Text(
                  //             "Add your work",
                  //             style: TextStyle(
                  //                 fontWeight: FontWeight.w500,
                  //                 color: Colors.white70),
                  //           ),
                  //         ))
                  //     : const SizedBox(
                  //         height: 10,
                  //       ),

                  for (String category in categories.keys)
                    if (categories[category]!.length >= 1 &&
                        category == category &&
                        !(categories[category]!
                            .any((map) => map["user_id"] == number)))
                      categoryWidget(categories, category, number),
                  const Divider(),
                  // const SizedBox(
                  //   height: 30,
                  // ),

                  //          'Electrician',
                  // 'Plumber',
                  // 'Welder',
                  // 'Carpenter',
                  // 'Painter',
                  // 'Mason',
                  // 'Tile Installer',
                  // 'Interior Designer',
                  // 'Bike Mechanic',
                  // 'Auto Mechanic',
                  // 'Teacher',
                  // 'Other'

                  if (categories.containsKey("other"))
                    categoryWidget(categories, "other", number),
                ],
              );
      },
    );
  }

  Widget yourJobListTile(
      {required String userName,
      required String userStatus,
      required String userType,
      required String userCity,
      required String userSubCity,
      required String thumbNail}) {
    bool isMy = true;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Padding(
        //   padding: const EdgeInsets.only(left:16.0),
        //   child: Text(
        //     "My".toUpperCase(),
        //     style: TextStyle(
        //         fontSize: 15,
        //         fontWeight: FontWeight.w500,
        //         color: Colors.black.withOpacity(0.5)),
        //   ),
        // ),
        ListTile(
          title: Text(userName.toString(),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
          subtitle: Text(
              userStatus != "available" ? "not at Availabe" : "at $userStatus",
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: NetworkImage(thumbNail),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserJobScreen(
                    ownership: "Jobs",
                    headName: userName,
                    jobCategory: userType,
                    userCity: userCity,
                    userSubCity: userSubCity,
                    number: number ?? "",
                    isMy: isMy),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget categoryWidget(dynamic categories, String job, dynamic number) {
    var totalVehicle = categories[job]?.take(categoriesLength).toList().length;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              job.toUpperCase(),
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black.withOpacity(0.5)),
            ),
          ),
          ...categories[job]!.take(categoriesLength).map((job) {
            return UserJobListTile(
              userId: job["user_id"],
              userName: job["name"],
              userStatus: job["status"],
              userCategory: job["category"],
              number: number,
              city: job["city"],
              subCity: job["sub_city"],
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
              )),
              onPressed: () {
                setState(() {
                  categoriesLength > totalVehicle
                      ? categoriesLength -= 4
                      : categoriesLength += 4;
                });
              },
            )
        ],
      ),
    );
  }
}
