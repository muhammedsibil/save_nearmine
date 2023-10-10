import 'package:flutter/material.dart';

import '../app_bussiness/screens/bussiness_screen/widgets/shops_list.dart';

class ListViewWidget extends StatelessWidget {
  const ListViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: 16,
        itemBuilder: (context, index) => Column(
          children: [
            ShopsList(
                // child: Text("${index}"),

                ),
            SizedBox(
              height: 15,
            ),
          ],
        ),
      );
}
