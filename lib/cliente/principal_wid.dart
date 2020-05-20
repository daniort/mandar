import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/pedidos_wid.dart';
import 'package:mandadero/cliente/perfil_wid.dart';

class ProfileCliente extends StatefulWidget {
  @override
  _ProfileClienteState createState() => _ProfileClienteState();
}

class _ProfileClienteState extends State<ProfileCliente> {
  int page = 0;
  final List<Widget> lista = [
    DataCliente(),
    Pedidos(),
  ];

  Widget inicio = DataCliente();

  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xff36827f), 
      
      body: PageStorage(
        child: inicio,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        
        //notchMargin: 1,
        //shape: AutomaticNotchedShape(_),
        child: Container(
          height: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              MaterialButton(
                onPressed: () {
                  setState(
                    () {
                      inicio = DataCliente();
                      page = 0;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.person,
                      color: page == 0 ? Color(0xff36827f) : Colors.grey,
                      size: 30,
                    ),
                    Text(
                      'Perfil',
                      style: TextStyle(
                          color: page == 0 ? Color(0xff36827f) : Colors.grey,
                          fontSize: 0),
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
                        color: page == 1 ? Color(0xff36827f) : Colors.grey,
                        size: 30),
                    Text(
                      'Pedidos',
                      style: TextStyle(
                          color: page == 1 ? Color(0xff36827f) : Colors.grey,
                          fontSize: 0),
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
        backgroundColor: Color(0xff36827f),
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          print('presionaste');
          //Navigator.pushNamed(context, nuevopedido);
        },
      ),
    );
  }
}
