import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class TomarPedido extends StatefulWidget {
  TomarPedido({Key key}) : super(key: key);

  @override
  _TomarPedidoState createState() => _TomarPedidoState();
}

class _TomarPedidoState extends State<TomarPedido> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _activos = 0;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff6f9ff),
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.grey,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        title: Text(
          'Toma un Pedido',
          style: TextStyle(color: Colors.grey),
        ),
        backgroundColor: Color(0xfff6f9ff),
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('pedidos')
                  .where("status", isEqualTo: "espera")
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
                            backgroundColor: Color(0xfff6f9ff),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.grey,
                            ),
                          ),
                        ),
                        new Text(
                          'Cargando...',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  default:
                    if (snapshot.data.documents.length == 0) {
                      return Container(
                        height: alto * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text('No hay pedidos disponibles por el momento',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.grey[400],
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold)),
                            Text('Vuelve en un momento',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 16,
                                )),
                          ],
                        ),
                      );
                    } else {
                      return new ListView(
                        children: snapshot.data.documents
                            .map((DocumentSnapshot document) {
                          if (document.data['cliente'] == _user.uid) {
                            return Text(
                              ' ',
                              style: TextStyle(fontSize: 1),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20.0, top: 5, bottom: 5),
                              child: Container(
                                color: Colors.grey[200],
                                width: ancho * .9,
                                child: new ExpansionTile(
                                  leading: Icon(
                                    document['tipo'] == 'pago'
                                        ? Icons.monetization_on
                                        : Icons.shop,
                                    color: Colors.deepOrange,
                                    size: 30,
                                  ),
                                  title:
                                      new Text(document['titulo'].toString()),
                                  subtitle: new Text("De: "),
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
                                    document['urlrecibocliente'] != 'null'
                                        ? ListTile(
                                            title: Container(
                                              child: Stack(
                                                children: <Widget>[
                                                  Center(
                                                    child: Image.network(
                                                      document[
                                                          'urlrecibocliente'],
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: IconButton(
                                                        color:
                                                            Color(0xffee6179),
                                                        icon: Icon(
                                                          Icons.remove_red_eye,
                                                          color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                         print('Ver Ticket');
                                                        }),
                                                  ),
                                                  
                                                ],
                                              ),
                                            ),
                                          )
                                        : SizedBox(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (_) {
                                                    return AlertDialog(
                                                      title: Center(
                                                          child: Text(
                                                              'Tomar Pedido')),
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
                                                          onPressed: () async {
                                                            bool _agregado =
                                                                await _tomarEstePedido(
                                                                    document
                                                                        .documentID,
                                                                    _user);

                                                            if (_agregado ==
                                                                true) {
                                                              print(_agregado);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();

                                                              _scaffoldKey
                                                                  .currentState
                                                                  .showSnackBar(
                                                                      SnackBar(
                                                                content: Text(
                                                                    'Pedido Tomado, Espera el PAgo'),
                                                                duration: Duration(
                                                                    milliseconds:
                                                                        3000),
                                                                backgroundColor:
                                                                    Color(
                                                                        0xff464d77),
                                                              ));
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            } else {
                                                              print(_agregado);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                                  content: Text(
                                                                      'Ya tienes un Pedido'),
                                                                  duration: Duration(
                                                                      milliseconds:
                                                                          3000),
                                                                  backgroundColor:
                                                                      Colors
                                                                          .deepOrange //Color(0xffd1495b),
                                                                  ));
                                                            }
                                                          },
                                                          color:
                                                              Color(0xff464d77),
                                                          child: Text(
                                                            'Aceptar',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                      content: RichText(
                                                        textAlign:
                                                            TextAlign.center,
                                                        text: TextSpan(
                                                          text: "Realiza: " +
                                                              document['titulo']
                                                                  .toString(),
                                                          style: DefaultTextStyle
                                                                  .of(context)
                                                              .style,
                                                          children: <TextSpan>[
                                                            TextSpan(
                                                                text: '\n',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                            TextSpan(
                                                              text:
                                                                  'Tómalo y espera el pago',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .grey,
                                                                  fontSize: 16),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  });
                                            },
                                            child: Container(
                                              color: Color(0xff464d77),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
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
        ],
      ),
    );
  }

  Future<bool> _tomarEstePedido(String documentID, FirebaseUser user) async {
    DocumentSnapshot _permiso = await Firestore.instance
        .collection('repartidores')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get();

    print('entonces el Estado: ' + _permiso.data['ocupado'].toString());

    if (_permiso.data['ocupado'] == null || _permiso.data['ocupado'] == false) {
      Firestore.instance.collection('pedidos').document(documentID).updateData(
          {'repartidor': user.uid, 'status': 'pagando'}).then((value) {
        Firestore.instance
            .collection('repartidores')
            .document(user.uid)
            .collection('datos')
            .document(user.uid)
            .updateData({'ocupado': true});
      });
      return true;
    } else {
      return false;
    }
  }
}
