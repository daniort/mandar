import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class TomarPedido extends StatefulWidget {
  TomarPedido({Key key}) : super(key: key);

  @override
  _TomarPedidoState createState() => _TomarPedidoState();
}

class _TomarPedidoState extends State<TomarPedido> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
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
                  .collection('users')
                  .document()
                  .collection('pedidos')
                  //.document().get()
                  //.where("status", isEqualTo: "espera")
                  .snapshots(),

              //.snapshots(),
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
                      print(snapshot.data.documents.length);
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
