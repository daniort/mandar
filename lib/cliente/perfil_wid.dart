import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';

import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class DataCliente extends StatefulWidget {
  @override
  _DataClienteState createState() => _DataClienteState();
}

class _DataClienteState extends State<DataCliente> {
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    //UserServices().newUser(_user);
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(20, 20, 20, 0.5),
                  ),
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                              title: Center(child: Text('Cerrar Sesión')),
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
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                      Provider.of<LoginState>(context, listen: false).logout();
                                      
                                  },
                                  color:  Color(0xffee6179),
                                  child: Text(
                                    'Salir',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              content: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: '¿Estas seguro de salir?',
                                  style: DefaultTextStyle.of(context).style,
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: '\n',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    TextSpan(text: 'Ya no podrás seguir tus pedidos.',style: TextStyle(color: Colors.grey),),
                                  ],
                                ),
                              ));
                        });
                  },
                ),
                Text(
                  'Cerrar Sesión',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(20, 20, 20, 0.5),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: alto * .25,
                      height: alto * .25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(20, 20, 20, 0.2), width: 5.0),
                        boxShadow: [
                          BoxShadow(color: Colors.white10, blurRadius: 25)
                        ],
                        image: new DecorationImage(
                            image: _user.photoUrl != null
                                ? NetworkImage("${_user.photoUrl}")
                                : Image.asset('lib/assets/logo.png'),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Text(
                    "Cliente",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xff484349),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  Text(
                    "${_user.displayName}",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff484349),
                        fontWeight: FontWeight.bold),
                  ),
                  _user.email != null ?  Text(
                    "${_user.email}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff484349),
                    ),
                  ):Text(''),
                ],
              ),
            ),
          ),
          Container(
            height: alto * 0.35,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff484349),
                  blurRadius: 20.0, // has the effect of softening the shadow
                  spreadRadius: 3.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    10.0, // vertical, move down 10
                  ),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xfff6f9ff),
                          ),
                          width: ancho * 0.5,
                          height: alto * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.pin_drop,
                                size: 17,
                                color: Color.fromRGBO(20, 20, 20, 0.5),
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                'Calle Guerrero No. 15',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(20, 20, 20, 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xfff6f9ff),
                          ),
                          width: ancho * 0.5,
                          height: alto * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              InkWell(
                                child: Text(
                                  'Editar Datos',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.bold),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed(editar);
                                },
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ancho * 0.35,
                        height: alto * 0.27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [Color(0xfff6f9ff), Color(0xfff6f9ff)],
                              begin: Alignment.topLeft),
                        ),
                        child: StreamBuilder<QuerySnapshot>(
                          stream: Firestore.instance
                              .collection('pedidos')
                              .where("cliente", isEqualTo: "${_user.uid}")
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError)
                              return new Text('Error: ${snapshot.error}');
                            switch (snapshot.connectionState) {
                              case ConnectionState.waiting:
                                return new Center(
                                    child: CircularProgressIndicator(
                                  backgroundColor: Colors.grey,
                                ));
                              default:
                                final _cantidad =
                                    snapshot.data.documents.length;
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Número de\nPedidos:',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff484349),
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '$_cantidad',
                                        style: TextStyle(
                                            color: Color(0xff484349),
                                            fontSize: 35,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        _cantidad == 0
                                            ? '¡Comienza Ahora!'
                                            : '¡Sigue así!',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Color(0xff484349),
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),
                                  ],
                                );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
