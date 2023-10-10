import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class BottomBarImageUploadWidget extends StatelessWidget {
  Function selectImage;
  bool isUploading;
  List<XFile> selectedFiles = [];
  Function uploadFunction;
    int uploadItem ;

  BottomBarImageUploadWidget(
      {Key? key,
      required this.selectImage,
      required this.isUploading,
      required this.selectedFiles,required this.uploadFunction, required this.uploadItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        isUploading
                ? SizedBox(
                    height: 40,
                    child: Column(
                      children: [
                        CircularProgressIndicator(),
                        Text("uploading: " + uploadItem.toString()),
                      ],
                    ),
                  ):SizedBox(),
        selectedFiles == null
                        ? Text("No Images Selected")
       :
        Wrap(

          children:selectedFiles
                                .map(
                                  (e) => SizedBox(
                                    height: 90,
                                    child: Image.file(File(e.path))),
                                )
                                .toList()),
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              color: Colors.red,
              width: 60,
              height: 60,
              child: OutlinedButton(
                onPressed: () {
                  selectImage();
                },
                child: Text("Select Files"),
              ),
            ),
            
            Container(
              color: Colors.green,
              width: 60,
              height: 60,
              child: ElevatedButton.icon(
                  onPressed: () {
                    if (selectedFiles.isNotEmpty) {
                      uploadFunction(selectedFiles);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please Select Images")));
                    }
                  },
                  icon: Icon(Icons.file_upload),
                  label: Text("Upload")),
            ),
          ],
        ),
      ],
    );
  }
}
