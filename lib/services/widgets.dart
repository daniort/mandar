import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

Future<double> totalDistancia(List list, var destino) async {
  double _startLatitude = destino['latitud'];
  double _startLongitude = destino['longitud'];
  List _listaTemporal = [...list];
  int _posmin = 0;
  double _disTotal = 0.0;
  while (_listaTemporal.isNotEmpty) {
    _listaTemporal = await 
        llenarDistancias(_listaTemporal, _startLatitude, _startLongitude);
    _posmin = posicionMenor(_listaTemporal);
    _disTotal = _disTotal + _listaTemporal[_posmin]['distancia'];
    _startLatitude = _listaTemporal[_posmin]['punto']['latitud'];
    _startLongitude = _listaTemporal[_posmin]['punto']['longitud'];
    //_listaTemporal.removeAt(_posmin);
    _listaTemporal.remove(_listaTemporal[_posmin]);
  }
  return _disTotal;
}

Future<double> totalDistanciaUnica(List list, var destino) async {
  double _startLatitude = destino['latitud'];
  double _startLongitude = destino['longitud'];
  List _listaTemporal = [...list];
  int _posmin = 0;
  double _disTotal = 0.0;
  while (_listaTemporal.isNotEmpty) {
    _listaTemporal = await 
        llenarDistancias(_listaTemporal, _startLatitude, _startLongitude);
    _posmin = posicionMenor(_listaTemporal);
    _disTotal = _disTotal + _listaTemporal[_posmin]['distancia'];
    _startLatitude = _listaTemporal[_posmin]['punto']['latitud'];
    _startLongitude = _listaTemporal[_posmin]['punto']['longitud'];
    //_listaTemporal.removeAt(_posmin);
    _listaTemporal.remove(_listaTemporal[_posmin]);
  }
  return _disTotal;
}

//print(":::DISTANCIA TOTAL: " + _disTotal.toString());
llenarDistancias(
    List listaTemporal, double startLatitude, double startLongitude) async {
  List _a = listaTemporal;
  for (var item in _a) {
    item['distancia'] = await Geolocator().distanceBetween(startLatitude,
        startLongitude, item['punto']['latitud'], item['punto']['longitud']);
  }
  return _a;
}

double porCompra(int sub) {
  double _por;
  if (sub >= 1000) _por = 0.02;
  if (sub >= 800 && sub <= 999) _por = 0.03;
  if (sub >= 500 && sub <= 799) _por = 0.05;
  if (sub >= 300 && sub <= 499) _por = 0.06;
  if (sub >= 100 && sub <= 299) _por = 0.08;
  if (sub <= 99) _por = 0.10;
  print("POR MONTO DE COMPRA: " + (sub * _por).toString());
  return sub * _por;
}

double precioDistancia(double disTotal) {
  if (disTotal < 1999.0) return 15;
  if (disTotal < 4999.0) return 25;
  if (disTotal < 7999.0) return 35;
  if (disTotal < 10999.0) return 45;
  if (disTotal < 13999.0) return 55;
  if (disTotal < 16999.0) return 65;
  if (disTotal < 19999.0) return 75;
  if (disTotal < 22999.0) return 85;
  if (disTotal < 25999.0) return 95;
  if (disTotal < 28999.0) return 105;
  if (disTotal < 31999.0) return 115;
  if (disTotal < 34999.0) return 125;
  if (disTotal >= 35000.0) return 150;
}

rellenarDestinos(List li) {
  //print("=======RELLENAR==DESTINOS==========");
  //print(li);
  List puntos = [];
  for (var item in li) {
    bool existe = false;
    if (puntos == null) {
      puntos.add(item['punto']);
    } else {
      for (var p in puntos) {
        if (p == item['punto']) {
          existe = true;
        }
      }
      if (!existe) {
        puntos.add(item['punto']);
      }
    }
  }
  //print("================================");
  //print(puntos);
  //print("================================");
  return puntos;
}

double comisionApp(double pre) {
  return pre * 0.029 + 2.50;
}

//////////////////////////////////////

int pieSubtotal(List list) {
  int _sub = 0;
  for (var item in list) {
    _sub = _sub + item['cantidad'];
  }
  return _sub;
}

double porDestinos(List list, int subtotal) {
  int _destinos = rellenarDestinos(list).length;
  print("CANTIDAD DE DESTINOS: " + _destinos.toString());
  if (_destinos <= 2) return subtotal * 0.10;
  if (_destinos <= 4) return subtotal * 0.08;
  if (_destinos <= 6) return subtotal * 0.06;
  if (_destinos <= 8) return subtotal * 0.05;
  if (_destinos <= 10) return subtotal * 0.03;
  if (_destinos >= 11) return subtotal * 0.02;
}


int posicionMenor(List li) {
  int _pos = 0;
  for (var i = 0; i < li.length; i++) {
    if (i == 0) {
      _pos = i;
    } else {
      if (li[i]['distancia'] < li[_pos]['distancia']) {
        _pos = i;
      }
    }
  }
  return _pos;
}

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

/////////////////////
///
///
///

Widget elegirUbicacion(
    BuildContext context, String uid, double alto, String s) {
  return Container(
    height: alto * .5,
    color: Colors.white,
    child: StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .document(uid)
          .collection("tiendas")
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return new Text('Loading...');
          default:
            return Column(
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Elige una ubicación',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            String _dire =
                                "${document['calle']}, #${document['numero']}, ${document['localidad']}, ${document['ciudad']}";
                            double longi = document['longitud'];
                            double lati = document['latitud'];
                            Provider.of<LoginState>(context, listen: false)
                                .setUbicacion(_dire, lati, longi, s);
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            color: Colors.grey[100],
                            child: new ListTile(
                              leading: Icon(Icons.store),
                              title: new Text(
                                document['nombre'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black54),
                              ),
                              subtitle: new Text(
                                  "${document['calle']}, #${document['numero']}, ${document['localidad']}, ${document['ciudad']}"),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
        }
      },
    ),
  );
}
