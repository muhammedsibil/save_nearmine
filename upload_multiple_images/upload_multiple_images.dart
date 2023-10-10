import 'dart:io';
import 'dart:math';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UploadMultipleImages extends StatefulWidget {
  const UploadMultipleImages({Key? key}) : super(key: key);

  @override
  State<UploadMultipleImages> createState() => _UploadMultipleImagesState();
}

class _UploadMultipleImagesState extends State<UploadMultipleImages> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _selectedFiles = [];
  List<String> _imageList = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String> _arrImageUrl = [];
  int uploadItem = 0;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    print("jjjjjjjjjjjjjjjjjjjj");
    print(_imageList.toString());
    return Scaffold(
      body: SafeArea(
        child: _isUploading
            ? Column(
                children: [
                  CircularProgressIndicator(),
                  Text("uploading: " + uploadItem.toString()),
                ],
              )
            : Column(
                children: [
                  // Image.network(
                  //     "https://firebasestorage.googleapis.com/v0/b/near-mine.appspot.com/o/multiple_images%2Fimage_picker5606030509850961916.jpg?alt=media&token=f20b0a4f-40f6-4f89-adaa-737cb4bd083e"),
                  //
                  _imageList.isNotEmpty
                      ? Column(
                          children: _imageList
                              .map((e) => SizedBox(
                                  height: 60,
                                  width: 30,
                                  child: Image.network(e.toString())))
                              .toList(),
                        )
                      : SizedBox(),
                  OutlinedButton(
                    onPressed: () {
                      selectImage();
                    },
                    child: Text("Select Files"),
                  ),
                  ElevatedButton.icon(
                      onPressed: () {
                        if (_selectedFiles.isNotEmpty) {
                          uploadFunction(_selectedFiles);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Please Select Images")));
                        }
                      },
                      icon: Icon(Icons.file_upload),
                      label: Text("Upload"),
                      ),
                  _selectedFiles == null
                      ? Text("No Images Selected")
                      : Expanded(
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: _selectedFiles.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Image.file(
                                    File(_selectedFiles[index].path));
                              }),
                        ),
                ],
              ),
      ),
    );
  }

  void uploadFunction(List<XFile> _images) {
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUrl = uploadFile(_images[i]);
      _arrImageUrl.add(imageUrl.toString());
    }
  }

  Future<String> uploadFile(XFile _image) async {
    Reference reference =
        _storageRef.ref().child("multiple_images").child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem++;
        if (uploadItem == _selectedFiles.length) {
          _isUploading = false;
          uploadItem = 0;
        }

        print(reference.getDownloadURL());
      });
    });
    String url = (await reference.getDownloadURL()).toString();
    // url = dowurl.toString();
    print("urlllllllllllllllllllllll");

    print(url);
    if (url.isNotEmpty) {
      _imageList.add(url);
    }
    // List<String> jj = [url.toString()];

    // return await reference.getDownloadURL();
    return url;
  }

  Future<void> selectImage() async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of selected images" + imgs.length.toString());
    } catch (e) {
      print("sometghing wrong" + e.toString());
    }
    setState(() {});
  }
}
