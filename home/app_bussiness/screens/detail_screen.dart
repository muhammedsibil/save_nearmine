import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String category;
  final String name;
  final String price;
  final Widget uploadProduct;
  final String urlImage;
  const DetailScreen(
      {Key? key,
      required this.category,
      required this.name,
      required this.price,
      required this.urlImage,
      required this.uploadProduct})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Column(
        children: [
          CachedNetworkImage(
            height: 300,
            imageUrl: urlImage,
            imageBuilder: (context, imageProvider) => Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
          Center(
            child: Text(name),
          ),
        ],
      )),
    );
  }
}
