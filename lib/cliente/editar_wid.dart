import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class EditarCliente extends StatefulWidget {
  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> {
  TextEditingController _emailController;
  TextEditingController _direccionController;
  TextEditingController _notaController;
  TextEditingController _cardController;
  TextEditingController _mesController;
  TextEditingController _anoController;

  void initState() {
    _direccionController = TextEditingController();
    _notaController = TextEditingController();
    _emailController = TextEditingController();
    _cardController = TextEditingController();
    _mesController = TextEditingController();
    _anoController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 15.0, right: 15.0, bottom: 15.0, top: 5),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            child: Center(
                              child: Text(
                                'Editar',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff11151C), fontSize: 27),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 12.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              border:
                                  Border(top: BorderSide(color: Colors.grey)),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 15.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.person),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                "${_user.displayName}",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xff484349),
                                  //fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _emailController,
                            maxLength: 30,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.email, color: Color(0xff11151C)),
                                labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _direccionController,
                            maxLength: 50,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.home, color: Color(0xff11151C)),
                                labelText: 'Direccion'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _notaController,
                            maxLength: 50,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.note, color: Color(0xff11151C)),
                                labelText:
                                    'Agregar etiqueta (p.ej. color de casa)'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _cardController,
                            maxLength: 16,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon: Icon(Icons.credit_card,
                                    color: Color(0xff11151C)),
                                labelText: 'Numero de Tarjeta'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 100,
                                child: TextField(
                                  controller: _mesController,
                                  maxLength: 2,
                                  cursorColor: Color(0xff11151C),
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.credit_card,
                                          color: Color(0xff11151C)),
                                      labelText: 'Mes'),
                                  autocorrect: false,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                width: 100,
                                child: TextField(
                                  controller: _anoController,
                                  maxLength: 2,
                                  cursorColor: Color(0xff11151C),
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.credit_card,
                                          color: Color(0xff11151C)),
                                      labelText: 'Año'),
                                  autocorrect: false,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0,
                                  bottom: 4.0,
                                  left: 10.0,
                                  right: 5.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Color(0xff36827f),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Center(
                                    child: Text(
                                      'Cancelar',
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 30.0,
                                  bottom: 4.0,
                                  //left: 10.0,
                                  right: 5.0),
                              child: InkWell(
                                onTap: () async {},
                                child: Container(
                                  height: 40,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Color(0xff36827f),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Center(
                                    child: Text(
                                      'Confirmar',
                                      style: TextStyle(
                                        color: Color(0xffffffff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

updateuser(FirebaseUser user, String direccion, String etiqueta, int tarjeta,
    int month, int year) async {
  var _direccion = "null";
  var _etiqueta = "null";
  var _tarjeta = "null";
  var _month = "null";
  var _year = "null";

  try {
    print('vamos a ver direccion');
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _direccion = doc["direccion"];
    });
  } catch (e) {
    print(e);
    print('error por que no hay direccion');
  }
  if (_direccion == "null") {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .setData({
      "direccion": direccion,
    });
  } else {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .updateData({
      "direccion": direccion,
    });
  }

  try {
    print('vamos a ver Etiqueta');
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _etiqueta = doc["etiqueta"];
    });
  } catch (e) {
    print(e);
    print('error por que no hay etiqueta');
  }
  if (_etiqueta == "null") {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .setData({
      "etiqueta": etiqueta,
    });
  }

  try {
    print('vamos a ver tarjeta');
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _direccion = doc["tarjeta"];
    });
  } catch (e) {
    print(e);
    print('error por que no hay tarjeta');
  }
  if (_tarjeta == "null") {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .setData({
      "tarjeta": tarjeta,
    });
  }

  try {
    print('vamos a ver mes');
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _month = doc["mes"];
    });
  } catch (e) {
    print(e);
    print('error por que no hay mes');
  }
  if (_month == "null") {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .setData({
      "mes": month,
    });
  }

  try {
    print('vamos a ver año');
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .get()
        .then((DocumentSnapshot doc) {
      _year = doc["año"];
    });
  } catch (e) {
    print(e);
    print('error por que no hay año');
  }
  if (_year == "null") {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .setData({
      "año": year,
    });
  }
}
