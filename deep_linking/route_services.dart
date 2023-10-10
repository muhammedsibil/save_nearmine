import 'package:flutter/material.dart';
import 'package:near_mine/deep_linking/home_page.dart';

import 'product_page.dart';

class RouteServices {
  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      case '/homepage':
        return MaterialPageRoute(builder: (_) {
          return HomeScreen();
        });

      case "/productpage":
       print(args);
        print("args");
        if (args is Map) {
          
          return MaterialPageRoute(builder: (_) {
            return ProductPage(
              productId: args["productId"],
            );
          });
        }
        return _errorRoute();
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Page Not Found"),
        ),
      );
    });
  }
}
