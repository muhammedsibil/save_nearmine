import 'package:flutter/material.dart';

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  double _currentScale = 1.0;

  @override
  Widget build(BuildContext context) {
    print("obmject");
    return Scaffold(
      body: Center(
        child: PageView(
          children: [
            WallView(
              scale: _currentScale,
              container: [
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
               
              ],
            ),
            WallView(
              scale: _currentScale,
              container: [
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
               
              ],
            ),
           
            WallView(
              scale: _currentScale,
              container: [
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                Container(
                  color: Colors.red,
                  height: 30,
                  width: 30,
                ),
                
              ],
            ),
            // ...
          ],
          onPageChanged: (index) {
            setState(() {
              _currentScale = 1.0 - (index * 0.1);
            });
          },
        ),
      ),
    );
  }
}

class WallView extends StatelessWidget {
  final List<Container>? container;
  final double scale;

  const WallView({Key? key, @required this.container, required this.scale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: scale,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: container?.length,
        itemBuilder: (context, index) {
          Container product = container![index];
          return Container(
            child: product,
            // decoration: BoxDecoration(
            //   image: DecorationImage(
            //     image: NetworkImage(product.image),
            //     fit: BoxFit.cover,
            //   ),
            // ),
          );
        },
      ),
    );
  }
}
