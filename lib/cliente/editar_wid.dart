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

  final _llave = GlobalKey<FormState>();
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
                    key: _llave,
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
                          padding: const EdgeInsets.only(top: 5.0),
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
                          child: TextFormField(
                            controller: _nameController,
                            maxLength: 30,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon: Icon(Icons.person,
                                    color: Color(0xff11151C)),
                                labelText: 'Nombre Completo',
                                helperText: 'Debes de Tener tu nombre real'),
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
                                icon:
                                    Icon(Icons.phone, color: Color(0xff11151C)),
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
                                icon:
                                    Icon(Icons.home, color: Color(0xff11151C)),
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
                                icon:
                                    Icon(Icons.note, color: Color(0xff11151C)),
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
                                    if (value.length < 2 && value.isNotEmpty) {
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
                                    if (value.length < 2 && value.isNotEmpty) {
                                      return "Año Incorrecto";
                                    }
                                    return null;
                                  },
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
                                onTap: () {
                                  if (_llave.currentState.validate()) {
                                    FirebaseUser user;

                                    Update().updateuser(_user, {
                                      _nameController.text,
                                      _emailController.text,
                                      _telefonoController.text,
                                      _direccionController.text,
                                      _notaController.text,
                                      _cardController.text,
                                      _mesController.text,
                                      _anoController.text,
                                    });
                                    print(nombre);
                                    print(correo);
                                    print(telefono);
                                    print(direccion);
                                    print(nota);
                                    print(tarjeta);
                                    print(mes);
                                    print(year);
                                  }

                                  //_nameController.clear();
                                  //_emailController.clear();
                                  //_telefonoController.clear();
                                  //_direccionController.clear();
                                  //_notaController.clear();
                                  //_cardController.clear();
                                  //_mesController.clear();
                                  //_anoController.clear();
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
