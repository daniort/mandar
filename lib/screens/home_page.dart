import 'package:flutter/material.dart';
import 'package:mandadero/Router/generateRouter.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/screens/profile_mandar.dart';
import 'package:mandadero/screens/profile_user.dart';

import 'package:mandadero/state/userstate.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<UserState>(
      create: (BuildContext context) => UserState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router().generateRoute,
        //initialRoute: mainRoute,
        //title: "Mandaderos",
        routes: {
          'mainRoute': (BuildContext context) {
            var stateuser = Provider.of<UserState>(context);
            if (stateuser.isTipe() == 1) {
              return ProfileCliente();
            } else {
              return ProfileMandadero();
            }
          }
        },
      ),
    );
  }
}
