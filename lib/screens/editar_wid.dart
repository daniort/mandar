import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_conekta/flutter_conekta.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
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
  TextEditingController _telefonoController;
  TextEditingController _direccionController;
  TextEditingController _notaController;

  TextEditingController _titularController;
  TextEditingController _cardController;
  TextEditingController _mesController;
  TextEditingController _anoController;
  TextEditingController _cvcController;

  File _image;
  final ImagePicker picker = ImagePicker();

  void initState() {
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _telefonoController = TextEditingController();
    _direccionController = TextEditingController();
    _notaController = TextEditingController();

    _titularController = TextEditingController();
    _cardController = TextEditingController();
    _mesController = TextEditingController();
    _anoController = TextEditingController();
    _cvcController = TextEditingController();

    super.initState();
  }

  String _token = "";

  String nombre;
  String correo;
  String direccion;
  String telefono;
  String nota;
  String titular;
  String tarjeta;
  String mes;
  String year;
  String cvc;
  bool aceptado;
  bool ocupa;
  String url;

  final _llave = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final _type_user =
        Provider.of<LoginState>(context, listen: false).isType_User();
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
          child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection(_type_user == 1 ? 'users' : 'repartidores')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (_type_user == 1) {
                return Stack(
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
                                      BlacklistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value.isNotEmpty &&
                                          value.length < 4) {
                                        return "Nombre Incompleto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                        if (value.contains('@') ||
                                            value.isEmpty) {
                                          return null;
                                        }
                                        return "Correo invalido";
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Numero de Telefono Incompleto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Direccion incompleta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Etiqueta Incompleta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 4.0),
                                  child: TextFormField(
                                    controller: _titularController,
                                    maxLength: 30,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.person,
                                            color: Color(0xff11151C)),
                                        labelText: 'Nombre del titular',
                                        helperText:
                                            'Tal y como viene en la tajeta'),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value.length == 0 ||
                                          value.length < 10) {
                                        return "Por favor escribe el nombre";
                                      }
                                      if (!(value.contains(
                                          new RegExp("^[^0-9]+\$")))) {
                                        return "El nombre no puede incluír números";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
                                  child: TextFormField(
                                    controller: _cardController,
                                    maxLength: 16,
                                    maxLengthEnforced: true,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.credit_card,
                                            color: Color(0xff11151C)),
                                        labelText: 'Número de Tarjeta'),
                                    autocorrect: false,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[a-z,A-Z]")),
                                    ],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.length != 16) {
                                        return "Se necesitan los 16 números de la tarjeta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 9.0,
                                      right: 15.0,
                                      bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 100,
                                        child: TextFormField(
                                          controller: _mesController,
                                          maxLength: 2,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'MM'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (int.tryParse(value) < 1 ||
                                                int.tryParse(value) > 12) {
                                              return "$value no es un mes válido";
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
                                          maxLength: 4,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'YYYY'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (value.length != 4) {
                                              return "Escribe el año en el formato YYYY";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 100,
                                        child: TextFormField(
                                          controller: _cvcController,
                                          maxLength: 3,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'CVC'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (value.length != 3) {
                                              return "Se necesitan los tres números detrás de tu tarjeta";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 9.0,
                                        right: 15.0,
                                        bottom: 200.0),
                                    child: _fotoINE(context))
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
                                        if (snapshot.data.documents.length ==
                                            1) {
                                          return InkWell(
                                            onTap: () {
                                              if (_llave.currentState
                                                  .validate()) {
                                                if (_nameController
                                                    .text.isEmpty) {
                                                  print('Nombre anterioro');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'nombre',
                                                      _nameController.text);
                                                }

                                                if (_emailController
                                                    .text.isEmpty) {
                                                  print('Correo anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'email',
                                                      _emailController.text);
                                                }

                                                if (_telefonoController
                                                    .text.isEmpty) {
                                                  print('Telefono anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'telefono',
                                                      _telefonoController.text);
                                                }

                                                if (_direccionController
                                                    .text.isEmpty) {
                                                  print('Direccion anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'direccion',
                                                      _direccionController
                                                          .text);
                                                }

                                                if (_notaController
                                                    .text.isEmpty) {
                                                  print('Nota anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'nota',
                                                      _notaController.text);
                                                }

                                                if (_cardController
                                                    .text.isEmpty) {
                                                  print('Tarjeta anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'tarjeta',
                                                      _cardController.text);
                                                }

                                                if (_mesController
                                                    .text.isEmpty) {
                                                  print('Mes anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'mes',
                                                      _mesController.text);
                                                }
                                                if (_anoController
                                                    .text.isEmpty) {
                                                  print('Año anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'año',
                                                      _anoController.text);
                                                }
                                                if (_nameController.text.isEmpty &&
                                                    _emailController
                                                        .text.isEmpty &&
                                                    _telefonoController
                                                        .text.isEmpty &&
                                                    _direccionController
                                                        .text.isEmpty &&
                                                    _notaController
                                                        .text.isEmpty &&
                                                    _cardController
                                                        .text.isEmpty &&
                                                    _mesController
                                                        .text.isEmpty &&
                                                    _anoController
                                                        .text.isEmpty) {
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
                                                      BorderRadius.circular(
                                                          10.0)),
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
                                            onTap: () async {
                                              if (_llave.currentState
                                                  .validate()) {
                                                String _url =
                                                    await _subirImagen(_image);
                                                //String token;

                                                //try {
                                                //token = await FlutterConekta
                                                //   .tokenizeCard(
                                                // cardholderName:
                                                //     _titularController.text,
                                                // cardNumber: _cardController.text,
                                                // cvv: _cvcController.text,
                                                // expiryMonth: _mesController.text,
                                                //// expiryYear: _anoController.text,
                                                // publicKey: 'your_key',
                                                // );
                                                //} catch (e) {
                                                // print(e.toString());
                                                //token = "Unable to tokenize card";
                                                //}

                                                //setState(() {
                                                //  _token = token;
                                                //  print('$token');
                                                //});

                                                UserServices().primero(
                                                  _type_user,
                                                  _user,
                                                  nombre = _nameController.text,
                                                  correo =
                                                      _emailController.text,
                                                  telefono =
                                                      _telefonoController.text,
                                                  direccion =
                                                      _direccionController.text,
                                                  nota = _notaController.text,
                                                  titular =
                                                      _titularController.text,
                                                  tarjeta =
                                                      _cardController.text,
                                                  mes = _mesController.text,
                                                  year = _anoController.text,
                                                  cvc = _cvcController.text,
                                                  url = _url,
                                                  // token = '$token',
                                                  aceptado = false,
                                                  ocupa = false,
                                                );

                                                Navigator.of(context).pop();

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
                                                      BorderRadius.circular(
                                                          10.0)),
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
                );
              } else {
                return Stack(
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
                                      BlacklistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value.isNotEmpty &&
                                          value.length < 4) {
                                        return "Nombre Incompleto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                        if (value.contains('@') ||
                                            value.isEmpty) {
                                          return null;
                                        }
                                        return "Correo invalido";
                                      }),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Numero de Telefono Incompleto";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Direccion incompleta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
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
                                      if (value.length < 10 &&
                                          value.isNotEmpty) {
                                        return "Etiqueta Incompleta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 4.0),
                                  child: TextFormField(
                                    controller: _titularController,
                                    maxLength: 30,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.person,
                                            color: Color(0xff11151C)),
                                        labelText: 'Nombre del titular',
                                        helperText:
                                            'Tal y como viene en la tajeta'),
                                    keyboardType: TextInputType.text,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[0-9]")),
                                    ],
                                    autocorrect: false,
                                    validator: (value) {
                                      if (value.length == 0 ||
                                          value.length < 10) {
                                        return "Por favor escribe el nombre";
                                      }
                                      if (!(value.contains(
                                          new RegExp("^[^0-9]+\$")))) {
                                        return "El nombre no puede incluír números";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 2.0,
                                      left: 15.0,
                                      right: 15.0,
                                      bottom: 2.0),
                                  child: TextFormField(
                                    controller: _cardController,
                                    maxLength: 16,
                                    maxLengthEnforced: true,
                                    cursorColor: Color(0xff11151C),
                                    decoration: InputDecoration(
                                        icon: Icon(Icons.credit_card,
                                            color: Color(0xff11151C)),
                                        labelText: 'Número de Tarjeta'),
                                    autocorrect: false,
                                    inputFormatters: [
                                      BlacklistingTextInputFormatter(
                                          RegExp("[a-z,A-Z]")),
                                    ],
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value.length != 16) {
                                        return "Se necesitan los 16 números de la tarjeta";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0,
                                      left: 9.0,
                                      right: 15.0,
                                      bottom: 10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Container(
                                        height: 50,
                                        width: 100,
                                        child: TextFormField(
                                          controller: _mesController,
                                          maxLength: 2,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'MM'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (int.tryParse(value) < 1 ||
                                                int.tryParse(value) > 12) {
                                              return "$value no es un mes válido";
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
                                          maxLength: 4,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'YYYY'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (value.length != 4) {
                                              return "Escribe el año en el formato YYYY";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      Container(
                                        height: 50,
                                        width: 100,
                                        child: TextFormField(
                                          controller: _cvcController,
                                          maxLength: 3,
                                          cursorColor: Color(0xff11151C),
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.credit_card,
                                                  color: Color(0xff11151C)),
                                              labelText: 'CVC'),
                                          autocorrect: false,
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            BlacklistingTextInputFormatter(
                                                RegExp("[a-z,A-Z]")),
                                          ],
                                          validator: (value) {
                                            if (value.length != 3) {
                                              return "Se necesitan los tres números detrás de tu tarjeta";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 9.0,
                                        right: 15.0,
                                        bottom: 100.0),
                                    child: _fotoINE(context)),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 9.0,
                                        right: 15.0,
                                        bottom: 100.0),
                                    child: _fotoConducir(context)),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0,
                                        left: 9.0,
                                        right: 15.0,
                                        bottom: 100.0),
                                    child: _fotoComprobante(context))
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
                                        if (snapshot.data.documents.length ==
                                            1) {
                                          return InkWell(
                                            onTap: () {
                                              if (_llave.currentState
                                                  .validate()) {
                                                if (_nameController
                                                    .text.isEmpty) {
                                                  print('Nombre anterioro');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'nombre',
                                                      _nameController.text);
                                                }

                                                if (_emailController
                                                    .text.isEmpty) {
                                                  print('Correo anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'email',
                                                      _emailController.text);
                                                }

                                                if (_telefonoController
                                                    .text.isEmpty) {
                                                  print('Telefono anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'telefono',
                                                      _telefonoController.text);
                                                }

                                                if (_direccionController
                                                    .text.isEmpty) {
                                                  print('Direccion anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'direccion',
                                                      _direccionController
                                                          .text);
                                                }

                                                if (_notaController
                                                    .text.isEmpty) {
                                                  print('Nota anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'nota',
                                                      _notaController.text);
                                                }

                                                if (_cardController
                                                    .text.isEmpty) {
                                                  print('Tarjeta anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'tarjeta',
                                                      _cardController.text);
                                                }

                                                if (_mesController
                                                    .text.isEmpty) {
                                                  print('Mes anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'mes',
                                                      _mesController.text);
                                                }
                                                if (_anoController
                                                    .text.isEmpty) {
                                                  print('Año anterior');
                                                } else {
                                                  UserServices().saveData(
                                                      _type_user,
                                                      _user,
                                                      'año',
                                                      _anoController.text);
                                                }
                                                if (_nameController.text.isEmpty &&
                                                    _emailController
                                                        .text.isEmpty &&
                                                    _telefonoController
                                                        .text.isEmpty &&
                                                    _direccionController
                                                        .text.isEmpty &&
                                                    _notaController
                                                        .text.isEmpty &&
                                                    _cardController
                                                        .text.isEmpty &&
                                                    _mesController
                                                        .text.isEmpty &&
                                                    _anoController
                                                        .text.isEmpty) {
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
                                                      BorderRadius.circular(
                                                          10.0)),
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
                                            onTap: () async {
                                              if (_llave.currentState
                                                  .validate()) {
                                                String _url =
                                                    await _subirImagen(_image);
                                                //String token;

                                                //try {
                                                //token = await FlutterConekta
                                                //   .tokenizeCard(
                                                // cardholderName:
                                                //     _titularController.text,
                                                // cardNumber: _cardController.text,
                                                // cvv: _cvcController.text,
                                                // expiryMonth: _mesController.text,
                                                //// expiryYear: _anoController.text,
                                                // publicKey: 'your_key',
                                                // );
                                                //} catch (e) {
                                                // print(e.toString());
                                                //token = "Unable to tokenize card";
                                                //}

                                                //setState(() {
                                                //  _token = token;
                                                //  print('$token');
                                                //});

                                                UserServices().primero(
                                                  _type_user,
                                                  _user,
                                                  nombre = _nameController.text,
                                                  correo =
                                                      _emailController.text,
                                                  telefono =
                                                      _telefonoController.text,
                                                  direccion =
                                                      _direccionController.text,
                                                  nota = _notaController.text,
                                                  titular =
                                                      _titularController.text,
                                                  tarjeta =
                                                      _cardController.text,
                                                  mes = _mesController.text,
                                                  year = _anoController.text,
                                                  cvc = _cvcController.text,
                                                  url = _url,
                                                  // token = '$token',
                                                  aceptado = false,
                                                  ocupa = false,
                                                );

                                                Navigator.of(context).pop();

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
                                                      BorderRadius.circular(
                                                          10.0)),
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
                );
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _fotoINE(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.pin_drop, color: Colors.grey),
                  ),
                  Text(
                    'Foto del INE:',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  print('tomar foto');
                  try {
                    _pickImage();
                  } catch (e) {
                    print("Error wee $e");
                  }
                },
                disabledColor: Colors.grey[300],
                color: Colors.grey[300],
                child: Flexible(
                    child: Text('Abrir Camara',
                        style: TextStyle(color: Colors.grey))),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: _image == null
                ? SizedBox()
                : Stack(
                    children: <Widget>[
                      Center(
                        child: Image.file(
                          _image,
                          width: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            color: Color(0xffee6179),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            }),
                      ),
                    ],
                  ),
          ),
        ),
        Text(
          _image == null
              ? 'Si cuentas con uno, seria de gran ayuda.'
              : 'Genial, lo Tenemos',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
      ],
    );
  }

  Widget _fotoConducir(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.pin_drop, color: Colors.grey),
                  ),
                  Expanded(
                    child: Text(
                      'Foto permiso de conducir:',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  print('tomar foto');
                  try {
                    _pickImage();
                  } catch (e) {
                    print("Error wee $e");
                  }
                },
                disabledColor: Colors.grey[300],
                color: Colors.grey[300],
                child: Flexible(
                    child: Text('Abrir Camara',
                        style: TextStyle(color: Colors.grey))),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: _image == null
                ? SizedBox()
                : Stack(
                    children: <Widget>[
                      Center(
                        child: Image.file(
                          _image,
                          width: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            color: Color(0xffee6179),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            }),
                      ),
                    ],
                  ),
          ),
        ),
        Text(
          _image == null
              ? 'Si cuentas con uno, seria de gran ayuda.'
              : 'Genial, lo Tenemos',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
      ],
    );
  }

  Widget _fotoComprobante(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.pin_drop, color: Colors.grey),
                  ),
                  Expanded(
                    child: Text(
                      'Foto de carta de no carcel:',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: MaterialButton(
                onPressed: () {
                  print('tomar foto');
                  try {
                    _pickImage();
                  } catch (e) {
                    print("Error wee $e");
                  }
                },
                disabledColor: Colors.grey[300],
                color: Colors.grey[300],
                child: Flexible(
                    child: Text('Abrir Camara',
                        style: TextStyle(color: Colors.grey))),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: _image == null
                ? SizedBox()
                : Stack(
                    children: <Widget>[
                      Center(
                        child: Image.file(
                          _image,
                          width: 70,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            color: Color(0xffee6179),
                            icon: Icon(
                              Icons.close,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                            }),
                      ),
                    ],
                  ),
          ),
        ),
        Text(
          _image == null
              ? 'Si cuentas con uno, seria de gran ayuda.'
              : 'Genial, lo Tenemos',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey, fontSize: 10.0),
        ),
      ],
    );
  }

  Future _pickImage() async {
    try {
      final select = await picker.getImage(source: ImageSource.camera);
      setState(() {
        _image = File(select.path);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _subirImagen(File image) async {
    StorageUploadTask _uploadTask;

    final FirebaseStorage _sto = LoginState().isStorage();
    String filePath = "ine/${DateTime.now()}.png";
    try {
      setState(() {
        _uploadTask = _sto.ref().child(filePath).putFile(_image);
      });
      var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();
      return url;
    } catch (e) {
      return 'null';
    }
  }
}
