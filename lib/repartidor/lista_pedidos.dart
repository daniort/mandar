import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mandadero/repartidor/finalizar_pedido.dart';
import 'package:mandadero/repartidor/seguimiento.dart';
import 'package:mandadero/services/colors.dart';
import 'package:mandadero/services/widgets.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';
import 'package:image_downloader/image_downloader.dart';

class MisPedidos extends StatefulWidget {
  @override
  _MisPedidosState createState() => _MisPedidosState();
}

class _MisPedidosState extends State<MisPedidos> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xfff6f9ff),
      appBar: AppBar(
          backgroundColor: Color(0xfff6f9ff),
          elevation: 0.0,
          centerTitle: true,
          title: Text(
            'Mis Pedidos',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(20, 20, 20, 0.5),
            ),
          )),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 3,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('pedidos')
                  .where('repartidor', isEqualTo: _user.uid)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                        )),
                        new Text('Cargando...',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    );
                  default:
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Text(
                            'No tienes Pedidos Activos,\n¡Comienza ahora!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 23,
                                fontWeight: FontWeight.bold)),
                      );
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          if (document['status'] != 'finalizado') {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 5, bottom: 5),
                              child: Container(
                                color: Colors.grey[200],
                                width: ancho * .9,
                                child: document['tipo'] == 'pago'
                                    ? _pedidoPago(document, context)
                                    : _pedidoProducto(document, context),
                              ),
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList(),
                      );
                    }
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Pedidos Finalizados',
                style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 1,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('pedidos')
                  .where('repartidor', isEqualTo: _user.uid)
                  .where('status', isEqualTo: 'finalizado')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                            child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                        )),
                        new Text('Cargando...',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    );
                  default:
                    if (snapshot.data.documents.length == 0) {
                      return Center(
                        child: Column(
                          children: <Widget>[
                            Icon(
                              Icons.arrow_drop_up,
                              size: 40,
                              color: Colors.grey,
                            ),
                            Text(
                                'No tienes Pedidos Finalizados Aún,\n¡Finaliza un Pedido ahora!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20.0, top: 5, bottom: 5),
                            child: Container(
                              color: Colors.grey[200],
                              width: ancho * .9,
                              child: new ListTile(
                                leading: document['status'] == "espera"
                                    ? Icon(
                                        Icons.check_circle,
                                        color: Colors.orange,
                                      )
                                    : document['status'] == "activo"
                                        ? Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                        : document['status'] == "pagando"
                                            ? Icon(
                                                Icons.check_circle,
                                                color: Colors.blue,
                                              )
                                            : Icon(
                                                Icons.check_circle,
                                                color: Colors.grey,
                                              ),
                                title: new Text(document['titulo'].toString()),
                                subtitle:
                                    new Text(document['status'].toString()),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  _pedidoPago(DocumentSnapshot document, BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        FontAwesomeIcons.moneyCheck,
        color: AppColorsR.primaryBackground,
        size: 30,
      ),
      title: new Text(
        'Paga un Servicio',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: new Text("Ganas: "),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.pin_drop),
          title: Text(document['puntoa']['label']),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Cantidad: \$ ${document['subtotal']}.00"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                onTap: () {},
                child: Container(
                  color: Color(0xff464d77),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Tomar Pedido',
                      style: TextStyle(
                        color: Color(0xfff6f9ff),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  _pedidoProducto(DocumentSnapshot document, BuildContext context) {
    return ExpansionTile(
      leading: Icon(
        FontAwesomeIcons.shoppingCart,
        color: AppColorsR.primaryBackground,
        size: 30,
      ),
      title: new Text(
        'Compra el Mandado',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle:
          new Text("Gánate: \$${_calcularCantidadPago(document['costo'])}"),
      children: <Widget>[
        ListTile(
          leading: Icon(Icons.person_pin),
          title: Text("${document['puntob']['label']}"),
          //subtitle:  _obtenerNombre(document['cliente']),
        ),
        ListTile(
          leading: Icon(Icons.attach_money),
          title: Text("Necesitas: \$${document['subtotal']}.00"),
        ),
        ListTile(
          leading: Icon(Icons.directions_transit),
          title: Text("${document['lista'].length} Paradas"),
        ),
        ListTile(
          title: ExpansionTile(
            title: Text("Lista:"),
            children: <Widget>[
              for (var item in document['lista'])
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: textoLista(
                            item['nombre'].toString().toUpperCase())),
                    SizedBox(width: 2),
                    Expanded(
                        flex: 2,
                        child: textoListaDirec(item['punto']['label'])),
                  ],
                ),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            MaterialButton(
              color: Colors.white,
              onPressed: () {
                print('llamar al cliente');
              },
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¿Tienes dudas?',
                    style: TextStyle(fontSize: 8),
                  ),
                  Text(
                    'Llamar al cliente',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            document['status'] == "pagando" 
                ? MaterialButton(
                    splashColor: Colors.white,
                    color: Colors.blueAccent[300],
                    child: Text(
                      'Esperando Pagando...',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  )
                : document['status'] == "activo" ? MaterialButton(
                    splashColor: Colors.white,
                    color: Color(0xff464d77),
                    onPressed: () {
                      Provider.of<LoginState>(context, listen: false)
                          .setPedidoActivo(document);
                    },
                    child: Text(
                      'Comenzar',
                      style: TextStyle(color: Colors.white),
                    ),
                  ):SizedBox(),
          ],
        )
      ],
    );
  }

  _calcularCantidadPago(double cos) {
    final double c = cos * 0.7;
    return redondear(c);
  }

  Widget textoLista(String s) {
    return Text("$s:",
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold));
  }

  Widget textoListaDirec(String s) {
    return Text(s, textAlign: TextAlign.left, style: TextStyle(fontSize: 12));
  }
}
