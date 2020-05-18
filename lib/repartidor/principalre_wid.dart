import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/pedidos_wid.dart';
import 'package:mandadero/cliente/perfil_wid.dart';

class PrincipalRepartidor extends StatefulWidget {
  @override
  _PrincipalRepartidorState createState() => _PrincipalRepartidorState();
}

class _PrincipalRepartidorState extends State<PrincipalRepartidor> {
  int page = 0;
  final List<Widget> lista = [
    Perfil(),
    Pedidos(),
  ];

  Widget inicio = Perfil();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    return Scaffold(
      body: PageStorage(
        child: inicio,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        shape: CircularNotchedRectangle(),
        child: Container(
          height: alto * .09,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      inicio = Perfil();
                      page = 0;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: page == 0 ? Color(0xffee6179) : Colors.grey,
                      size: alto * .05,
                    ),
                    Text(
                      'Perfil',
                      style: TextStyle(
                          color: page == 0 ? Color(0xffee6179) : Colors.grey,
                          fontSize: alto * .03),
                    ),
                  ],
                ),
              ),
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      inicio = Pedidos();
                      page = 1;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.note,
                        color: page == 1 ? Color(0xffee6179) : Colors.grey,
                        size: alto * .05),
                    Text(
                      'Pedidos',
                      style: TextStyle(
                          color: page == 1 ? Color(0xffee6179) : Colors.grey,
                          fontSize: alto * .03),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xffee6179),
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: null,
      ),
    );
  }
}
