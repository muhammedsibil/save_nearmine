import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Description extends StatefulWidget {
  const Description({super.key, required this.name});
  final String name;
  @override
  State<Description> createState() => _DescriptionState();
}

class _DescriptionState extends State<Description> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              var child;
                return DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.70,
                    minChildSize: 0.60,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      child ??= Container(
                        // height: MediaQuery.of(context).size.height * 0.4,
                        child: Stack(
                          children: [
                            SingleChildScrollView(
                              controller: scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 8.0),
                                    for (var i = 0; i < 10; i++)
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "Product DescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescriptionDescription",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyText2),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 50,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.black.withOpacity(0.1),
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 190,
                                      child: Text("Description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline5),
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(Icons.close,  color: Colors.black54,)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                      return child;
                    });
              
            });
      },
      child: Column(
        children: [
          Icon(Icons.description,color: Colors.black54),
           SizedBox(height: 4,),
          Text(
            "Description",
            style: TextStyle(
              fontSize: 10,
             color:  Colors.black87
            ),
          ),
        ],
      ),
    );
  }
}
