import 'package:flutter/material.dart';

import '../../vehicle_owner_screen/vehicle_owner_screen.dart';

class VehicleListTile extends StatelessWidget {
  const VehicleListTile(
      {super.key,
      required this.vehicleName,
      required this.vehicleStatus,
      required this.vehicleCategory});
  final String vehicleName;
  final bool vehicleStatus;
  final String vehicleCategory;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(vehicleName.toString(),
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w500, color: Colors.black)),
      subtitle: Text(vehicleStatus == true ? "at Stand" : "not at stand",
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
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
              builder: (context) => VehicleOwnerScreen(
                    headName: vehicleName,
                    vehicleCategory: vehicleCategory,
                  )),
        );
      },
    );
  }
}
