import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/cliente/perfil_wid.dart';
import 'package:mandadero/cliente/principal_wid.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:
                Text('Pedidos en Curso:', style: TextStyle(color: Colors.grey)),
          ),
          Expanded(
            flex: 4,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('pedidos')
                  .where('cliente', isEqualTo: _user.uid)
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
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                      );
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          if (document.data['status'] == 'finalizado') {
                            return Text(' ', style: TextStyle(fontSize: 1));
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 5, bottom: 5),
                              child: Container(
                                color: Colors.grey[200],
                                width: ancho * .9,
                                child: new ExpansionTile(
                                  initiallyExpanded:
                                      document['status'] == 'pagando'
                                          ? true
                                          : false,
                                  leading: Icon(
                                    _returnIcon(document['tipo'].toString()),
                                    color: _returnColorIcon(
                                        document['status'].toString()),
                                  ),
                                  title: Text(document['titulo']
                                      .toString()
                                      .toUpperCase()),
                                  subtitle: Text(document['status'] +
                                      "...".toString().toLowerCase()),
                                  children: <Widget>[
                                    ListTile(
                                      leading: Icon(Icons.pin_drop),
                                      title: Text(document['ubicacion'] != null
                                          ? 'A elección'
                                          : "${document['ubicacion']}"),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.attach_money),
                                      title: Text(document['cantidad']),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.info),
                                      title: Text(
                                          "Info Extra: " + document['datos']),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          document['status'] != 'activo'
                                              ? _botonEliminar(
                                                  document.documentID)
                                              : Text(
                                                  ' ',
                                                  style: TextStyle(fontSize: 1),
                                                ),
                                          document['status'] == 'pagando'
                                              ? _botonPagar(document.documentID)
                                              : Text(
                                                  ' ',
                                                  style: TextStyle(fontSize: 1),
                                                ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
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
            flex: 2,
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('pedidos')
                  .where('cliente', isEqualTo: _user.uid)
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
                      return Text('Vacio',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 15,
                              fontWeight: FontWeight.bold));
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
                                leading: Icon(
                                  _returnIcon(document['tipo'].toString()),
                                  color: _returnColorIcon(
                                      document['status'].toString()),
                                ),
                                title: Text(document['titulo']
                                    .toString()
                                    .toUpperCase()),
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

  IconData _returnIcon(String document) {
    if (document == "pago") {
      return Icons.monetization_on;
    } else {
      return Icons.shopping_cart;
    }
  }

  _returnColorIcon(String string) {
    if (string == "finalizado") {
      return Colors.grey;
    }
    if (string == "espera") {
      return Colors.orange;
    }
    if (string == "pagando") {
      return Colors.blue;
    }
    if (string == "activo") {
      return Colors.green;
    }
  }

  _botonPagar(String documentID) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Center(child: Text('Pagar Pedido')),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async{
                        bool _realizado = await _pagarPedido(documentID);
                         if (_realizado) {
                          Navigator.of(context).pop();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Repartidor en Curso'),
                            duration: Duration(milliseconds: 3000),
                            backgroundColor: Colors.blue//Color(0xffee6179),
                          ));
                        } else {
                          Navigator.of(context).pop();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Intentalo de nuevo'),
                            duration: Duration(milliseconds: 3000),
                            backgroundColor: Color(0xffee6179),
                          ));
                        }
                      },
                      color: Colors.blue,
                      child: Text(
                        'Pagar con Tarjeta',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  content: Text('Realiza el Pago para Continuar'),
                );
              });
        },
        child: Container(
          color: Colors.blue,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Pagar',
              style: TextStyle(color: Color(0xfff6f9ff)),
            ),
          ),
        ),
      ),
    );
  }

  _botonEliminar(String documentID) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Center(child: Text('Cancelar Pedido')),
                  actions: <Widget>[
                    MaterialButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancelar',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        bool _realizado = await _eliminarPedido(documentID);
                        if (_realizado) {
                          Navigator.of(context).pop();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Eliminaste un Pedido'),
                            duration: Duration(milliseconds: 3000),
                            backgroundColor: Color(0xffee6179),
                          ));
                        } else {
                          Navigator.of(context).pop();
                          _scaffoldKey.currentState.showSnackBar(SnackBar(
                            content: Text('Intentalo de nuevo'),
                            duration: Duration(milliseconds: 3000),
                            backgroundColor: Color(0xffee6179),
                          ));
                        }
                      },
                      color: Color(0xffee6179),
                      child: Text(
                        'Si, Cancelar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  content: Text("¿Estas Seguro de Cancelar este pedido?"),
                );
              });
        },
        child: Container(
          color: Color(0xffee6179),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Cancelar Pedido',
              style: TextStyle(
                color: Color(0xfff6f9ff),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _eliminarPedido(String documentID) async {
    try {
      Firestore.instance.collection('pedidos').document(documentID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _pagarPedido(String documentID) async {
    print('pagando...');

    try {
      if (true) {
        Firestore.instance
            .collection('pedidos')
            .document(documentID)
            .updateData({'status': 'activo'});
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
