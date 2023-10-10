// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../home/app_bussiness/provider/provider_bussiness.dart';
import '../chat_screen.dart';

class BottomBarDetailsUploadWidget extends StatefulWidget {
  final String? categoryPass;
  final String? category;
  TextEditingController pro_name;
  TextEditingController pro_price;
  var storeMessage;
  Function toImage;
  List<String> imageListFetched;
  List<String> imageList;
  bool imageUploadCompleted;
  Function uploadImagesAndDescriptions;

  BottomBarDetailsUploadWidget(
      {Key? key,
      required this.category,
      required this.pro_name,
      required this.pro_price,
      this.storeMessage,
      required this.toImage,
      required this.imageListFetched,
      required this.imageList,
      required this.imageUploadCompleted,
      required this.uploadImagesAndDescriptions,
      this.categoryPass})
      : super(key: key);

  @override
  State<BottomBarDetailsUploadWidget> createState() =>
      _BottomBarDetailsUploadWidgetState();
}

class _BottomBarDetailsUploadWidgetState
    extends State<BottomBarDetailsUploadWidget> {
  @override
  Widget build(BuildContext context) {
    var uploadCategory = context.watch<ProviderBussiness>().uploadCategory;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextButton(
          // readOnly: true,
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) {
                var categories = context.watch<ProviderBussiness>().categories;
                return AlertDialog(
                  title: const Text('Title'),
                  content: Column(
                    children: categories
                        .map((category) => TextButton(
                            onPressed: () {
                              context
                                  .read<ProviderBussiness>()
                                  .addCategory(category);
                              Navigator.pop(context);
                            },
                            child: Text(category)))
                        .toList(),
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.all(6),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.07),
                border: const Border(
                    top: BorderSide(color: Colors.blue, width: 0.3))),
            child: Text(uploadCategory),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.07),
              border: const Border(
                  top: BorderSide(color: Colors.blue, width: 0.3))),
          child: TextField(
            controller: widget.pro_name,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: 'Enter Product Name...'),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.07),
            border: const Border(
              top: BorderSide(color: Colors.blue, width: 0.3),
            ),
          ),
          child: TextField(
            controller: widget.pro_price,
            decoration: const InputDecoration(
                contentPadding: EdgeInsets.all(16),
                hintText: 'Enter Product Price...'),
          ),
        ),
      ],
    );
  }
}
