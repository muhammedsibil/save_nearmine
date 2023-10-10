import 'package:flutter/material.dart';

import 'widgets/user_job_list.dart';
import 'widgets/user_job_list_tile.dart';

class UserJobTabScreen extends StatefulWidget {
  const UserJobTabScreen({Key? key}) : super(key: key);

  @override
  State<UserJobTabScreen> createState() => _UserJobTabScreenState();
}

class _UserJobTabScreenState extends State<UserJobTabScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: UserJobList(),
    );
  }
}
