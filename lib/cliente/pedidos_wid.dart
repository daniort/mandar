import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
  @override
  void initState() {
    print('hola muno');
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Color.fromRGBO(20, 20, 20, 0.5),
                    ),
                    onPressed: () {
                      Provider.of<LoginState>(context, listen: false).logout();
                    },
                  ),
                  Text(
                    'Salir',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(20, 20, 20, 0.5),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('users')
                  .document(_user.uid)
                  .collection('pedidos')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError)
                  return new Text('Error: ${snapshot.error}');
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return new Text('Loading...');
                  default:
                    return new ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            color: Colors.grey[200],
                            width: ancho *.9,
                            child: new ListTile(
                              leading: document['status'] == "espera" 
                              ? Icon(Icons.check_circle, color: Colors.orange,)
                              : document['status'] == "activo" 
                              ?  Icon(Icons.check_circle, color: Colors.green,)
                              :  Icon(Icons.check_circle, color: Colors.grey,),
                              title: new Text(document['titulo'].toString()),
                              subtitle: new Text(document['status'].toString()),
                            ),
                          ),
                        );
                      }).toList(),
                    );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
