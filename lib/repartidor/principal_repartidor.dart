import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/repartidor/lista_pedidos.dart';
import 'package:mandadero/repartidor/perfil_repartidor.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class ProfileMandadero extends StatefulWidget {
  @override
  ProfileMandaderoState createState() => ProfileMandaderoState();
}

class ProfileMandaderoState extends State<ProfileMandadero> {
  int page = 0;
  final List<Widget> lista = [
    DataRepartidor(),
    MisPedidos(),
  ];
  Widget inicio = DataRepartidor();
  final PageStorageBucket bucket = PageStorageBucket();

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
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
                      inicio = DataRepartidor();
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
                      inicio = MisPedidos();
                      page = 1;
                    },
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.view_list,
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
        backgroundColor: Color(0xff464d77), //Color(0xffee6179),
        child: Icon(
          Icons.add,
          size: 30,
        ),
        onPressed: () {
          print('presionaste');
         Navigator.of(context).pushNamed(tomarPedidoRoute);
        },
      ),
    );
  }
}