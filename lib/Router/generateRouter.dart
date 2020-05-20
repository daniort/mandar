import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/main.dart';
import 'package:mandadero/screens/home_page.dart';
import 'package:mandadero/screens/login.dart';
import 'package:mandadero/screens/profile_user.dart';
import 'package:mandadero/screens/regsitro.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => MyApp());
      case signRoute:
        return MaterialPageRoute(builder: (_) => Sign());
      case homeRoute:
        return MaterialPageRoute(builder: (_) => Home());
      case perfilclienteRoute:
        return MaterialPageRoute(builder: (_) => ProfileCliente());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => Login());
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
