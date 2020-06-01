import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/cliente/perfil_wid.dart';
import 'package:mandadero/cliente/principal_wid.dart';
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
    return Scaffold(
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
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('repartidores')
                  .document(_user.uid)
                  .collection('pedidos')
                  .orderBy('status')
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
                        child: Text('No tienes Pedidos Aun,\n¡Comienza ahora!',
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
