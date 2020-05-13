



import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/screens/regsitro.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signRoute:
        return MaterialPageRoute(builder: (_) => Sign());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}