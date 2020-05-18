import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/perfil_wid.dart';
import 'package:mandadero/screens/login.dart';
import 'package:mandadero/screens/regsitro.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signRoute:
        return MaterialPageRoute(builder: (_) => Sign());
      case perfilclienteRoute:
        return MaterialPageRoute(builder: (_) => Perfil());
      case loginClienteRoute:
        return MaterialPageRoute(builder: (_) => LoginCliente());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
