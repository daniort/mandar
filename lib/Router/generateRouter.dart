import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/nuevo_pedido.dart';
import 'package:mandadero/cliente/principal_wid.dart';
import 'package:mandadero/main.dart';

import 'package:mandadero/screens/login.dart';

import 'package:mandadero/screens/regsitro.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case mainRoute:
        return MaterialPageRoute(builder: (_) => MyApp());
      case signRoute:
        return MaterialPageRoute(builder: (_) => Sign());
      case nuevoPedidoRoute:
        return MaterialPageRoute(builder: (_) => NuevoPedido());
      case perfilclienteRoute:
        return MaterialPageRoute(builder: (_) => ProfileCliente());
      case loginRoute:
        return MaterialPageRoute(builder: (_) => Login());
      default:
        return MaterialPageRoute(builder: (_) => MyApp());
    }
  }
}
