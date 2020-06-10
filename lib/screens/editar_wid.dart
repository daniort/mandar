import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class EditarUser extends StatefulWidget {
  @override
  _EditarUserState createState() => _EditarUserState();
}

class _EditarUserState extends State<EditarUser> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _direccionController;
  TextEditingController _notaController;
  TextEditingController _cardController;
  TextEditingController _mesController;
  TextEditingController _anoController;
  TextEditingController _telefonoController;

  void initState() {
    _nameController = TextEditingController();
    _direccionController = TextEditingController();
    _notaController = TextEditingController();
    _emailController = TextEditingController();
    _cardController = TextEditingController();
    _mesController = TextEditingController();
    _anoController = TextEditingController();
    _telefonoController = TextEditingController();
    super.initState();
  }

  String nombre;
  String correo;
  String direccion;
  String telefono;
  String nota;
  String tarjeta;
  String mes;
  String year;
  bool ocupa;

  final _llave = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff6f4f3),
      appBar: AppBar(
        backgroundColor: Color(0xfff6f4f3),
        iconTheme: IconThemeData(
          color: Colors.grey,
        ),
        title: Text(
          'Editar Datos',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: SingleChildScrollView(
                    child: Form(
                      key: _llave,
                      child: Column(
                        children: <Widget>[
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 20.0, left: 40.0, right: 40.0),
                              child: Text(
                                'Necesitamos tus datos para confirmar que eres tu, despues, pide lo que desees',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0,
                                left: 15.0,
                                right: 15.0,
                                bottom: 2.0),
                            child: TextFormField(
                              controller: _nameController,
                              maxLength: 30,
                              cursorColor: Color(0xff11151C),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.person,
                                      color: Color(0xff11151C)),
                                  labelText: 'Nombre Completo',
                                  helperText: 'Ingresa tu nombre real'),
                              keyboardType: TextInputType.text,
                              inputFormatters: [
                                BlacklistingTextInputFormatter(RegExp("[0-9]")),
                              ],
                              autocorrect: false,
                              validator: (value) {
                                if (value.isNotEmpty && value.length < 4) {
                                  return "Nombre Incompleto";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: TextFormField(
                                controller: _emailController,
                                maxLength: 30,
                                cursorColor: Color(0xff11151C),
                                decoration: InputDecoration(
                                    icon: Icon(Icons.email,
                                        color: Color(0xff11151C)),
                                    labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                autocorrect: false,
                                validator: (value) {
                                  if (value.contains('@') || value.isEmpty) {
                                    return null;
                                  }
                                  return "Correo invalido";
                                }),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: TextFormField(
                              controller: _telefonoController,
                              maxLength: 10,
                              maxLengthEnforced: true,
                              cursorColor: Color(0xff11151C),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.phone,
                                      color: Color(0xff11151C)),
                                  labelText: 'Numero de Telefono'),
                              autocorrect: false,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                BlacklistingTextInputFormatter(
                                    RegExp("[a-z,A-Z]")),
                              ],
                              validator: (value) {
                                if (value.length < 10 && value.isNotEmpty) {
                                  return "Numero de Telefono Incompleto";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: TextFormField(
                              controller: _direccionController,
                              maxLength: 50,
                              cursorColor: Color(0xff11151C),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.home,
                                      color: Color(0xff11151C)),
                                  labelText: 'Direccion'),
                              keyboardType: TextInputType.emailAddress,
                              autocorrect: false,
                              validator: (value) {
                                if (value.length < 10 && value.isNotEmpty) {
                                  return "Direccion incompleta";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: TextFormField(
                              controller: _notaController,
                              maxLength: 50,
                              cursorColor: Color(0xff11151C),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.note,
                                      color: Color(0xff11151C)),
                                  labelText:
                                      'Agregar etiqueta (p.ej. color de casa)'),
                              autocorrect: false,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value.length < 10 && value.isNotEmpty) {
                                  return "Etiqueta Incompleta";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: TextFormField(
                              controller: _cardController,
                              maxLength: 16,
                              maxLengthEnforced: true,
                              cursorColor: Color(0xff11151C),
                              decoration: InputDecoration(
                                  icon: Icon(Icons.credit_card,
                                      color: Color(0xff11151C)),
                                  labelText: 'Numero de Tarjeta'),
                              autocorrect: false,
                              inputFormatters: [
                                BlacklistingTextInputFormatter(
                                    RegExp("[a-z,A-Z]")),
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value.length < 16 && value.isNotEmpty) {
                                  return "Numero de Tarjeta Incompleto";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 4.0, left: 15.0, right: 15.0, bottom: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  height: 50,
                                  width: 120,
                                  child: TextFormField(
                                    controller: _mesController,
                                    maxLength: 2,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.credit_card,
                                            color: Color(0xff11151C)),
                                        labelText: 'Mes'),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[a-z,A-Z]")),
                                    ],
                                    validator: (value) {
                                      if (value.length < 2 &&
                                          value.isNotEmpty) {
                                        return "Mes incorrecto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 120,
                                  child: TextFormField(
                                    controller: _anoController,
                                    maxLength: 2,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.credit_card,
                                            color: Color(0xff11151C)),
                                        labelText: 'Año'),
                                    autocorrect: false,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[a-z,A-Z]")),
                                    ],
                                    validator: (value) {
                                      if (value.length < 2 &&
                                          value.isNotEmpty) {
                                        return "Año Incorrecto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.red,
                    Color(0xffee6179),
                  ])),
                  height: alto * .06,
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
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
                      Expanded(
                        child: Container(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: Firestore.instance
                                .collection('users')
                                .document(_user.uid)
                                .collection('datos')
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              switch (snapshot.connectionState) {
                                default:
                                  if (snapshot.data.documents.length == 1) {
                                    return InkWell(
                                      onTap: () {
                                        if (_llave.currentState.validate()) {
                                          if (_nameController.text.isEmpty) {
                                            print('Nombre anterioro');
                                          } else {
                                            UserServices().saveData(_user,
                                                'nombre', _nameController.text);
                                          }

                                          if (_emailController.text.isEmpty) {
                                            print('Correo anterior');
                                          } else {
                                            UserServices().saveData(_user,
                                                'email', _emailController.text);
                                          }

                                          if (_telefonoController
                                              .text.isEmpty) {
                                            print('Telefono anterior');
                                          } else {
                                            UserServices().saveData(
                                                _user,
                                                'telefono',
                                                _telefonoController.text);
                                          }

                                          if (_direccionController
                                              .text.isEmpty) {
                                            print('Direccion anterior');
                                          } else {
                                            UserServices().saveData(
                                                _user,
                                                'direccion',
                                                _direccionController.text);
                                          }

                                          if (_notaController.text.isEmpty) {
                                            print('Nota anterior');
                                          } else {
                                            UserServices().saveData(_user,
                                                'nota', _notaController.text);
                                          }

                                          if (_cardController.text.isEmpty) {
                                            print('Tarjeta anterior');
                                          } else {
                                            UserServices().saveData(
                                                _user,
                                                'tarjeta',
                                                _cardController.text);
                                          }

                                          if (_mesController.text.isEmpty) {
                                            print('Mes anterior');
                                          } else {
                                            UserServices().saveData(_user,
                                                'mes', _mesController.text);
                                          }
                                          if (_anoController.text.isEmpty) {
                                            print('Año anterior');
                                          } else {
                                            UserServices().saveData(_user,
                                                'año', _anoController.text);
                                          }
                                          if (_nameController.text.isEmpty &&
                                              _emailController.text.isEmpty &&
                                              _telefonoController
                                                  .text.isEmpty &&
                                              _direccionController
                                                  .text.isEmpty &&
                                              _notaController.text.isEmpty &&
                                              _cardController.text.isEmpty &&
                                              _mesController.text.isEmpty &&
                                              _anoController.text.isEmpty) {
                                            print('No hace nada');
                                          } else {
                                            Navigator.of(context).pop();
                                          }

                                          _nameController.clear();
                                          _emailController.clear();
                                          _telefonoController.clear();
                                          _direccionController.clear();
                                          _notaController.clear();
                                          _cardController.clear();
                                          _mesController.clear();
                                          _anoController.clear();
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0)),
                                        child: Center(
                                          child: Text(
                                            'Guardar',
                                            style: TextStyle(
                                              color: Color(0xffffffff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return InkWell(
                                      onTap: () {
                                        if (_llave.currentState.validate()) {
                                          UserServices().primero(
                                            _user,
                                            nombre = _nameController.text,
                                            correo = _emailController.text,
                                            telefono = _telefonoController.text,
                                            direccion =
                                                _direccionController.text,
                                            tarjeta = _cardController.text,
                                            nota = _notaController.text,
                                            mes = _mesController.text,
                                            year = _anoController.text,
                                            ocupa = false,
                                          );
                                          if (_nameController.text.isEmpty &&
                                              _emailController.text.isEmpty &&
                                              _telefonoController
                                                  .text.isEmpty &&
                                              _direccionController
                                                  .text.isEmpty &&
                                              _notaController.text.isEmpty &&
                                              _cardController.text.isEmpty &&
                                              _mesController.text.isEmpty &&
                                              _anoController.text.isEmpty &&
                                              ocupa) {
                                            print('No hace nada');
                                          } else {
                                            Navigator.of(context).pop();
                                          }

                                          _nameController.clear();
                                          _emailController.clear();
                                          _telefonoController.clear();
                                          _direccionController.clear();
                                          _notaController.clear();
                                          _cardController.clear();
                                          _mesController.clear();
                                          _anoController.clear();
                                        }
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 150,
                                        decoration: BoxDecoration(
                                            color: Color(0xffee6179),
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
                                    );
                                  }
                              }
                            },
                          ),
                        ),
                      ),
                    ],
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
