import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/principal_wid.dart';

import 'package:mandadero/screens/first_page.dart';

import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

import 'Router/generateRouter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router().generateRoute,
        initialRoute: mainRoute,
        title: "Mandaderos",
        routes: {
          mainRoute: (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLogin()) {
              if (state.isTipe() == 1) {
                return PrincipalCliente();
              } else {
                return PrincipalCliente();
              }
            } else {
              return FirtsPage();
            }
          }
        },
      ),
    );
  }
}
