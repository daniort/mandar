import 'package:flutter/material.dart';

class Pedido extends StatefulWidget {
  @override
  _PedidoState createState() => _PedidoState();
}

class _PedidoState extends State<Pedido> {
  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Column(
        children: <Widget>[
          new Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: StreamBuilder(
                stream: Firestore.instance
                    .collection('directorio_representaciones')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  List<DocumentSnapshot> docs = snapshot.data.documents;
                  docs.sort((a, b) {
                    return a['representacion']
                        .toLowerCase()
                        .compareTo(b['representacion'].toLowerCase());
                  });

                  return ListView.builder(
                    itemCount: (docs.length),
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = docs[index].data;
                      var dire = data['direccion'];
                      final direurl = dire.replaceAll(" ", "+");
                      return ExpansionTile(
                        backgroundColor: Color(0x1D605e5f),
                        title: Text(
                          data['representacion'],
                          style: TextStyle(
                              color: Color(0xFF262626),
                              fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(data['nombre']),
                        //'initiallyExpanded: true,
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
