import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/cliente/perfil_wid.dart';
import 'package:mandadero/cliente/principal_wid.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

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
    final _scaffoldKey = GlobalKey<ScaffoldState>();
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
                                child: ExpansionTile(
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
                                  title: new Text(document['titulo']
                                      .toString()
                                      .toUpperCase()),
                                  subtitle: document['status'] == "activo"
                                      ? new Text(
                                          "Vamos allá, realiza este pedido")
                                      : new Text(document['status'].toString()),
                                  initiallyExpanded:
                                      document['status'] == "activo"
                                          ? true
                                          : false,
                                  children: <Widget>[
                                    new ListTile(
                                      leading: Icon(Icons.pin_drop),
                                      title: Text("Paga en: " +
                                          document['ubicacion']
                                              .toString()
                                              .toUpperCase()),
                                    ),
                                    new ListTile(
                                      leading: Icon(Icons.attach_money),
                                      title: Text("La Cantidad de: " +
                                          document['cantidad']
                                              .toString()
                                              .toUpperCase()),
                                    ),
                                    new ListTile(
                                      leading: Icon(Icons.edit),
                                      title: Text("Datos Extras: " +
                                          document['datos']
                                              .toString()
                                              .toUpperCase()),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        MaterialButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            print('llamar al cliente');
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                '¿Tienes dudas?',
                                                style: TextStyle(fontSize: 10),
                                              ),
                                              Text('Llamar al cliente'),
                                            ],
                                          ),
                                        ),
                                        document['status'] == 'activo'
                                            ? MaterialButton(
                                                splashColor: Colors.white,
                                                color: Color(0xff464d77),
                                                onPressed: () {
                                                  print('finalziar pedido');
                                                  showDialog(
                                                      context: context,
                                                      builder: (_) {
                                                        return AlertDialog(
                                                          title: Center(
                                                              child: Text(
                                                                  "¿Estas seguro?")),
                                                          actions: <Widget>[
                                                            MaterialButton(
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              child: Text(
                                                                'Cancelar',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .grey),
                                                              ),
                                                            ),
                                                            MaterialButton(
                                                               onPressed: () {
                                                                //Finalizar Pedido
                                                                bool
                                                                    _finalRepartidor =
                                                                    UserServices.finalizaRepartidor(
                                                                        document
                                                                            .documentID,
                                                                        _user);
                                                                if (_finalRepartidor) {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                                      content: Text(
                                                                          'Genial, Sigue así'),
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              3000),
                                                                      backgroundColor:
                                                                          Color(
                                                                              0xff464d77) //Color(0xffd1495b),
                                                                      ));
                                                                } else {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pop();
                                                                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                                      content: Text(
                                                                          'Disculpa, Intentalo de Nuevo'),
                                                                      duration: Duration(
                                                                          milliseconds:
                                                                              3000),
                                                                      backgroundColor:
                                                                          Colors
                                                                              .orange));
                                                                }
                                                              },
                                                              color: Color(
                                                                  0xff464d77),
                                                              child: Text(
                                                                'Finalizar',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ),
                                                          ],
                                                          content: Text(
                                                              '¿Estas Seguro de que ya finalizaste?',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey)),
                                                        );
                                                      });
                                                },
                                                child: Text(
                                                  'Finalizé el Pedido',
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          } else {
                            return Text(
                              ' ',
                              style: TextStyle(fontSize: 1),
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
}
