import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screen/user_job_screen.dart';

class MyJobList extends StatefulWidget {
  const MyJobList({super.key});

  @override
  State<MyJobList> createState() => _MyJobListState();
}

class _MyJobListState extends State<MyJobList> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setNumber();
  }

  var stringValue;
  var number;
  var city;
  var subCity;
  var ownership;
  setNumber() async {
    // var number = Provider.of<CityModel>(context, listen: false).numberShop;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {});
    stringValue = prefs.getString('stringValue');
    number = prefs.getString('number');
    city = prefs.getString('city');
    subCity = prefs.getString('subCity');
    ownership = prefs.getString('ownership');

    //  void _saveData() async {
    //           SharedPreferences prefs = await SharedPreferences.getInstance();
    //           await prefs.setString('number', number);
    //           await prefs.setString('city', city);
    //           await prefs.setString('subCity', subCity);
    //           await prefs.setString('ownership', ownership);

    //           print(prefs.getString(number));
    //           print("getString");
    //         }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Place")
          .doc(city)
          .collection("SubCity")
          .doc(subCity)
          .collection("Jobs")
          .limit(1)
          .where('user_id', isEqualTo: number)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        if (snapshot.hasData) {
          // Process the data and build your UI here
          final users = snapshot.data!.docs;

          return SizedBox(
            height: 101,
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final userid = userData['user_id'] as String;
                final thumbNail = userData['thumb_nail'] as String;
                final userName = userData['user_name'] as String;
                final userType = userData['user_type'] as String;
                final userCity = userData['user_city'] as String;
                final userSubCity = userData['user_sub_city'] as String;

                return !(userid == number)
                    ? Container(
                        // padding: const EdgeInsets.all(8.0),
                        width: double.infinity,
                        alignment: Alignment.center,
                        // height: 60,

                        color: Colors.black87,
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserJobScreen(
                                  isMy: true,
                                  ownership: "User",
                                  headName: "your work",
                                  jobCategory: "Add",
                                  userCity: city,
                                  userSubCity: subCity,
                                  number: number ?? "",
                                ),
                              ),
                            );
                          },
                          leading: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.add_circle,
                              color: Colors.white70,
                            ),
                          ),
                          title: const Text(
                            "Add your work",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Colors.white70),
                          ),
                        ))
                    : ListTile(
                        title: Text(userName.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w500)),
                        subtitle: Text(
                            "not at Availabe"
                            "at ",
                            style: const TextStyle(
                                fontSize: 13, fontWeight: FontWeight.w500)),
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
                                  isMy: true),
                            ),
                          );
                        },
                      );
              },
            ),
          );
        }

        return const Text('No data available');
      },
    );
  }
}
