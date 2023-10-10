import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:near_mine/home/app_user/provider/provider_user.dart';
import 'package:provider/provider.dart';

import '../../../../../../../find_city/provider/data.dart';

// class MyOrdersCount extends StatelessWidget {
//   const MyOrdersCount({super.key, required this.number});
//   final String number;
//   @override
//   Widget build(BuildContext context) {
//     print("hii $number");
//     return  StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection("Place")
//           .doc("manjeri")
//           .collection("SubCity")
//           .doc("elankur")
//           .collection("Shop")
//           .doc(number)
//           .collection("Order")
//           .where('orderRequist', isEqualTo: "not_accept")
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }

//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Text('Loading...');
//         }

//         // Calculate the new orders count by subtracting the total orders count
//         // from the orders that have been marked as processed
//         int newOrdersCount = snapshot.data!.docs.length;
//         // snapshot.data!.docs
//         //     .where((doc) => doc['orderRequist'] == "accepted")
//         //     .length;

//         return newOrdersCount == 0
//             ? const Icon(
//                 Icons.check_circle,
//                 color: Colors.black,
//                 size: 14.0,
//               )
//             : Container(
//                 width: 24,
//                 height: 24,
//                 decoration: const BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: Colors.black,
//                 ),
//                 child: FittedBox(
//                   fit: BoxFit.scaleDown,
//                   child: Text(
//                     '$newOrdersCount',
//                     style: TextStyle(
//                       fontSize: newOrdersCount > 10 ? 10 : 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ));
//       },
//     );
//   }
// }

class MyOrdersCount extends StatefulWidget {
  const MyOrdersCount({
    Key? key,
  }) : super(key: key);

  // final String? shopId;

  @override
  State<MyOrdersCount> createState() => _MyOrdersCountState();
}

class _MyOrdersCountState extends State<MyOrdersCount> {
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<CityModel>(context, listen: false);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("Place")
          .doc("manjeri")
          .collection("SubCity")
          .doc("elankur")
          .collection("Shop")
          .doc(data.numberShop)
          .collection('Order')
          .where('orderRequist', isEqualTo: "not_accept")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        final int newOrdersCount = snapshot.data!.docs.length;

        return newOrdersCount == 0
            ? const Icon(
                Icons.check_circle,
                color: Colors.black,
                size: 14.0,
              )
            : Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '$newOrdersCount',
                    style: TextStyle(
                      fontSize: newOrdersCount > 10 ? 10 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
      },
    );
  }
}
