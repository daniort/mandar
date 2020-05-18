import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/screens/first_page.dart';
import 'package:mandadero/screens/home_page.dart';
import 'package:mandadero/screens/login.dart';
import 'package:mandadero/screens/profile_mandar.dart';
import 'package:mandadero/screens/profile_user.dart';
import 'package:mandadero/screens/regsitro.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:mandadero/state/userstate.dart';

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
            final _token = Provider.of<LoginState>(context).isToken();
            final _state = Provider.of<LoginState>(context).isType_User();
            if (_token.length >= 1) {
              if (_state == 1) {
                return ProfileCliente();
              } 
              if (_state == 2) {
                return ProfileMandadero();
              } 
            } else {
              switch (Provider.of<LoginState>(context).isLogin_Step()) {
                case 1:
                  return FirtsPage();
                case 2:
                  return Login();
                case 3:
                  return Sign();

                  break;
                default:
              }
            }
          }
        },
      ),
    );
  }
}
