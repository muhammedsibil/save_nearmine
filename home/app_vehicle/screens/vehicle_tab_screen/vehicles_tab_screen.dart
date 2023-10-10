import 'package:flutter/material.dart';

import '../../../app_user/widgets/user_chat_Bussiness.dart';
import 'widgets/vehicle_list.dart';

class VehiclesTabScreen extends StatefulWidget {
  const VehiclesTabScreen({Key? key}) : super(key: key);

  @override
  State<VehiclesTabScreen> createState() => _VehiclesTabScreenState();
}

class _VehiclesTabScreenState extends State<VehiclesTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: VehicleList(),
    );
  }
}
