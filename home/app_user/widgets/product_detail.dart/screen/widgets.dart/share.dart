import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:io';

import 'package:file_selector/file_selector.dart'
    hide XFile; // hides to test if share_plus exports XFile
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'
    hide XFile; // hides to test if share_plus exports XFile
import 'package:share_plus/share_plus.dart';

import '../../../../../../utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class ImagePreviews extends StatelessWidget {
  /// The image paths of the displayed images
  final List<String> imagePaths;

  /// Callback when an image should be removed
  final Function(int)? onDelete;

  /// Creates a widget for preview of images. [imagePaths] can not be empty
  /// and all contained paths need to be non empty.
  const ImagePreviews(this.imagePaths, {Key? key, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imagePaths.isEmpty) {
      return const SizedBox.shrink();
    }

    final imageWidgets = <Widget>[];
    for (var i = 0; i < imagePaths.length; i++) {
      imageWidgets.add(_ImagePreview(
        imagePaths[i],
        onDelete: onDelete != null ? () => onDelete!(i) : null,
      ));
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: imageWidgets),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final String imagePath;
  final VoidCallback? onDelete;

  const _ImagePreview(this.imagePath, {Key? key, this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageFile = File(imagePath);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 200,
              maxHeight: 200,
            ),
            child: kIsWeb ? Image.network(imagePath) : Image.file(imageFile),
          ),
          Positioned(
            right: 0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FloatingActionButton(
                  backgroundColor: Colors.red,
                  onPressed: onDelete,
                  child: const Icon(Icons.delete)),
            ),
          ),
        ],
      ),
    );
  }
}

class DemoApp extends StatefulWidget {
  const DemoApp({Key? key}) : super(key: key);

  @override
  DemoAppState createState() => DemoAppState();
}

class DemoAppState extends State<DemoApp> {
  String text = '';
  String subject = '';
  List<String> imageNames = [];
  List<String> imagePaths = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share Plus Plugin Demo'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share text',
                hintText: 'Enter some text and/or link to share',
              ),
              maxLines: null,
              onChanged: (String value) => setState(() {
                text = value;
              }),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Share subject',
                hintText: 'Enter subject to share (optional)',
              ),
              maxLines: null,
              onChanged: (String value) => setState(() {
                subject = value;
              }),
            ),
            const SizedBox(height: 16),
            ImagePreviews(imagePaths, onDelete: _onDeleteImage),
            ElevatedButton.icon(
              label: const Text('Add image'),
              onPressed: () async {
                // Using `package:image_picker` to get image from gallery.
                if (!kIsWeb &&
                    (Platform.isMacOS ||
                        Platform.isLinux ||
                        Platform.isWindows)) {
                  // Using `package:file_selector` on windows, macos & Linux, since `package:image_picker` is not supported.
                  const XTypeGroup typeGroup = XTypeGroup(
                    label: 'images',
                    extensions: <String>['jpg', 'jpeg', 'png', 'gif'],
                  );
                  final file = await openFile(
                      acceptedTypeGroups: <XTypeGroup>[typeGroup]);
                  if (file != null) {
                    setState(() {
                      imagePaths.add(file.path);
                      imageNames.add(file.name);
                    });
                  }
                } else {
                  final imagePicker = ImagePicker();
                  final pickedFile = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedFile != null) {
                    setState(() {
                      imagePaths.add(pickedFile.path);
                      imageNames.add(pickedFile.name);
                    });
                  }
                }
              },
              icon: const Icon(Icons.add),
            ),
            const SizedBox(height: 32),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: text.isEmpty && imagePaths.isEmpty
                      ? null
                      : () => _onShare(context),
                  child: const Text('Share'),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: text.isEmpty && imagePaths.isEmpty
                      ? null
                      : () => _onShareWithResult(context),
                  child: const Text('Share With Result'),
                );
              },
            ),
            const SizedBox(height: 16),
            Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    _onShareXFileFromAssets(context);
                  },
                  child: const Text('Share XFile from Assets'),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _onDeleteImage(int position) {
    setState(() {
      imagePaths.removeAt(position);
      imageNames.removeAt(position);
    });
  }

  void _onShare(BuildContext context) async {
   
    final box = context.findRenderObject() as RenderBox?;

    if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      await Share.share(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
  }

  void _onShareWithResult(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    ShareResult shareResult;
    if (imagePaths.isNotEmpty) {
      final files = <XFile>[];
      for (var i = 0; i < imagePaths.length; i++) {
        files.add(XFile(imagePaths[i], name: imageNames[i]));
      }
      shareResult = await Share.shareXFiles(files,
          text: text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      shareResult = await Share.shareWithResult(text,
          subject: subject,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  void _onShareXFileFromAssets(BuildContext context) async {
    final box = context.findRenderObject() as RenderBox?;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final data = await rootBundle.load('assets/flutter_logo.png');
    final buffer = data.buffer;
    final shareResult = await Share.shareXFiles(
      [
        XFile.fromData(
          buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
          name: 'flutter_logo.png',
          mimeType: 'image/png',
        ),
      ],
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );

    scaffoldMessenger.showSnackBar(getResultSnackBar(shareResult));
  }

  SnackBar getResultSnackBar(ShareResult result) {
    return SnackBar(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Share result: ${result.status}"),
          if (result.status == ShareResultStatus.success)
            Text("Shared to: ${result.raw}")
        ],
      ),
    );
  }
}
