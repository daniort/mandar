import 'package:flutter/material.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class ProfileMandadero extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.blueGrey,
      body: Center(
        child: Container(
          child: MaterialButton(
              onPressed: () {
                Provider.of<LoginState>(context,listen: false).logout();
              },
              color: Colors.red,
               child: Text('Salir')),
        ),
      ),
    );
  }
}
