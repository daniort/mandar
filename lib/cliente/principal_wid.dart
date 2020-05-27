import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/nuevo_pedido.dart';
import 'package:mandadero/cliente/pedidos_wid.dart';
import 'package:mandadero/cliente/perfil_wid.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class ProfileCliente extends StatefulWidget {
  @override
  ProfileClienteState createState() => ProfileClienteState();
}

class ProfileClienteState extends State<ProfileCliente> {
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
      backgroundColor: Color(0xfff6f9ff),
      body: PageStorage(
        child: inicio,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
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
                      color: page == 0
                          ? Color(0xff484349)
                          : Color.fromRGBO(20, 20, 20, 0.4),
                      size: 30,
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
                        color: page == 1
                            ? Color(0xff484349)
                            : Color.fromRGBO(20, 20, 20, 0.4),
                        size: 30),
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
        onPressed: () {
          print('presionaste');

          Navigator.of(context).pushNamed(nuevoPedidoRoute);
          //showModalBottomSheet(
          //  context: context,
          //isScrollControlled: true,
          //builder: (context) {
//                return NuevoPedido();
          //            });
        },
      ),
    );
  }

}
