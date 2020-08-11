import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mandadero/state/loginstate.dart';

Widget iconDeleteRed() {
  return Icon(Icons.delete);
}

Widget pieTablaRigth(String s) {
  return Text(
    s,
    textAlign: TextAlign.right,
    style: TextStyle(fontSize: 14, color: Colors.grey),
  );
}

Widget tituloTabla(String s) {
  return Center(
    child: Text(
      s,
      style: TextStyle(fontSize: 13, color: Colors.grey),
    ),
  );
}

Widget pieTabla(String s) {
  return Text(
    s,
    style: TextStyle(fontSize: 14, color: Colors.grey),
  );
}

Widget iconDeleteRedDos(String x, LoginState stados) {
  return Padding(
      padding: const EdgeInsets.only(right: 10.0, left: 10.0),
      child: IconButton(
        icon: Icon(
          Icons.cancel,
          color: Color.fromRGBO(238, 97, 121, 0.7),
        ),
        onPressed: () {
          stados.limpiarUbicacion(x);
        },
      ));
}

Widget buildItem(String item) {
  return new ListTile(
    title: new Text(item.toString()),
    leading: new Icon(Icons.map),
  );
}

Widget esperaRepartidor(double ancho, double alto) {
  return Column(
    children: <Widget>[
      Text(
        '¡Tu Pedido esta registrado!',
        style: TextStyle(
            fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
      ),
      Image.asset('lib/assets/giphy.gif'),
      Text(
        'Buscando Repartidor...',
        style: TextStyle(fontSize: 20),
      ),
    ],
  );
}

redondear(double number) {
  int fac = pow(10, 2);
  return (number * fac).round() / fac;
}
