import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/screens/first_page.dart';
import 'package:mandadero/screens/home_page.dart';
import 'package:mandadero/screens/profile_mandar.dart';
import 'package:mandadero/screens/profile_user.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:mandadero/state/userstate.dart';

import 'package:provider/provider.dart';

import 'Router/generateRouter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginState>(
          create: (BuildContext context) => LoginState(),
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: Router().generateRoute,
            initialRoute: mainRoute,
            title: "Mandaderos",
            routes: {
              mainRoute: (BuildContext context) {
                if (Provider.of<LoginState>(context).isLogin()) {
                  return Home();
                } else {
                  return FirtsPage();
                }
              }
            },
          ),
        ),
        Provider(
          create: (BuildContext context) => UserState(),
         )
      ],
      child: MyApp(),
    );
  }
}
