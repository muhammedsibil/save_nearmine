import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import '../../../../../../deep_linking/path_constant.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ShareProduct extends StatefulWidget {
  const ShareProduct(
      {super.key,
      required this.price,
      required this.category,
      required this.number,
      required this.city,
      required this.subCity,
      required this.urlImage});
  final String price;
  final String category;
  final String number;
  final String city;
  final String subCity;
  final String urlImage;
  @override
  State<ShareProduct> createState() => _ShareProductState();
}

class _ShareProductState extends State<ShareProduct> {
  String text = "";
//  final String subject = '';
//  final List<String> imageNames = [];
//  final List<String> imagePaths = [];
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;
  String _linkMessage = "";
  @override
  void initState() {
    super.initState();
    getImageXFileByUrl(widget.urlImage);
    text =
        "/productpage?id=,${widget.city},${widget.subCity},${widget.number},${widget.category},${widget.price}";

    print(text);
    _createDynamicLink(text);
  }

  late final Uri url;
  Future<void> _createDynamicLink(String link) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: kUriPrefix,
      link: Uri.parse(kUriPrefix + link),
      androidParameters: const AndroidParameters(
        packageName: 'com.example.near_mine',
        minimumVersion: 0,
      ),
    );

    if (1 == 3) {
      final ShortDynamicLink shortLink =
          await dynamicLinks.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } else {
      url = await dynamicLinks.buildLink(parameters);
    }

    setState(() {
      _linkMessage = url.toString();
    });
  }

  final List<XFile> shareImageXFile = [];
  Future<List<XFile>> getImageXFileByUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    XFile result = await XFile(file.path);
    shareImageXFile.add(result);
    return shareImageXFile;
  }

  @override
  Widget build(BuildContext context) {
    text = _linkMessage!;
    return Builder(
      builder: (BuildContext context) {
        return IconButton(
          // style: ElevatedButton.styleFrom(
          //   foregroundColor: Theme.of(context).colorScheme.onPrimary,
          //   backgroundColor: Theme.of(context).colorScheme.primary,
          // ),
          onPressed: () async {
            final box = context.findRenderObject() as RenderBox?;

            if (shareImageXFile.isNotEmpty) {
              await Share.shareXFiles(shareImageXFile,
                  text: text,
                  sharePositionOrigin:
                      box!.localToGlobal(Offset.zero) & box.size);
            }
          },
          // onPressed: text.isEmpty ? null : () => _onShare(context),
          icon: Icon(
            Icons.share,
            color: Colors.black.withOpacity(0.4),
          ),
        );
      },
    );
  }

  // void _onShare(BuildContext context) async {
  //   final box = context.findRenderObject() as RenderBox?;

  //   if (imagePaths.isNotEmpty) {
  //     final files = <XFile>[];
  //     for (var i = 0; i < imagePaths.length; i++) {
  //       files.add(XFile(imagePaths[i], name: imageNames[i]));
  //     }
  //     await Share.shareXFiles(files,
  //         text: text,
  //         subject: subject,
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   } else {
  //     await Share.share(text,
  //         subject: subject,
  //         sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
  //   }
  // }
}
