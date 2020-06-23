import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandadero/cliente/nueva_ubi.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class NuevoPedido extends StatefulWidget {
  @override
  _NuevoPedidoState createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
  TextEditingController _tituloController;
  TextEditingController _datosController;
  TextEditingController _cantidadController;
  TextEditingController _ubicacionController;
  int subtotal = 0;
  File _image;
  List orderLines = <Map>[];
  final ImagePicker picker = ImagePicker();
  final _formPedidoKey = GlobalKey<FormState>();
  final _formPedidoProductoKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    _tituloController = TextEditingController();
    _datosController = TextEditingController();
    _cantidadController = TextEditingController();
    _ubicacionController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    final _state = Provider.of<LoginState>(context, listen: true);

    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      backgroundColor: Color(0xfff6f9ff),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        '¿Que Necesitas?',
                        style: GoogleFonts.courgette(
                          fontSize: 35,
                          color: Color(0xff292f36),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Divider(
                    height: 5,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: SingleChildScrollView(
                child: _firstForm(context, ancho, alto, _state.currentUser()),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        switch (_state.isStepPedido()) {
                          case 0:
                            Navigator.of(context).pop();
                            break;
                          case 1:
                            Provider.of<LoginState>(context, listen: false)
                                .backStep();
                            break;
                          case 2:
                            _cleanDataPedido();
                            Navigator.of(context).pop();
                            break;
                          default:
                        }
                      },
                      child: Container(
                        height: 45.0,
                        //width: ancho * .5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffec506b), Color(0xffee6179)],
                              begin: Alignment.topLeft),
                          //color: Color(0xffee6179),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1.0, height: 45.0, color: Color(0xffeb425f)),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        switch (_state.isStepPedido()) {
                          case 1:
                            if (_state.isTipoPedido() == 1) {
                              if (_formPedidoKey.currentState.validate()) {
                                print('valido, amonos');
                                showModalBottomSheet(
                                    elevation: alto * 0.35,
                                    backgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.1),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _modalTicket(alto, ancho, 12);
                                    });
                              }
                            } else if (_state.isTipoPedido() == 2) {
                              if (orderLines.isNotEmpty) {
                                showModalBottomSheet(
                                    elevation: alto * 0.35,
                                    backgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.1),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _modalTicket(
                                          alto, ancho, subtotal);
                                    });
                              }
                            }

                            break;
                          case 2:
                            _cleanDataPedido();
                            Navigator.of(context).pop();
                            break;
                          default:
                        }
                      },
                      child: Container(
                        height: 45.0,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffee6179), Color(0xffec506b)],
                              begin: Alignment.topLeft),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: Align(
                              alignment: Alignment.centerRight,
                              child: Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.white,
                              )),
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

  _firstForm(BuildContext context, double ancho, double alto,
      FirebaseUser currentUser) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    switch (_stados.isStepPedido()) {
      case 0:
        return _tipoChoose(ancho, alto);
        break;
      case 1:
        if (_stados.isTipoPedido() == 1) {
          return _formServicio(ancho, alto, currentUser, context);
        }
        if (_stados.isTipoPedido() == 2) {
          return _formProducto(ancho, alto, currentUser, context);
        }
        break;
      case 2:
        print('Paso ${_stados.isStepPedido()}');
        return _esperaRepartidor(ancho, alto);
        break;
      case 3:
        print('Paso ${_stados.isStepPedido()}');
        //return _pagoChoose(ancho, alto);
        break;
      default:
    }
  }

  Widget iconDeleteRed(String x, LoginState stados) {
    return Padding(
        padding: const EdgeInsets.only(right: 10.0, left: 10.0),
        child: IconButton(
          icon: Icon(
            Icons.cancel,
            color: Color.fromRGBO(238, 97, 121, 0.7),
          ),
          onPressed: () {
            stados.limpiarUbicacion(x);
          },
        ));
  }

  Widget _formProducto(double ancho, double alto, FirebaseUser currentUser,
      BuildContext context) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    return Padding(
      padding:
          const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
      child: Form(
        key: _formPedidoProductoKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _tituloController,
                keyboardType: TextInputType.text,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Descrpción/Nombre del Producto',
                  helperText: "Ejemplo: Tortillas",
                  prefixIcon: Icon(Icons.shopping_cart),
                  //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '¿Que Compra haremos?';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _cantidadController,
                      decoration: InputDecoration(
                          helperText: "En Pesos",
                          prefixIcon: Icon(Icons.attach_money),
                          labelText: '10'),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        BlacklistingTextInputFormatter(RegExp("[a-z,A-Z]")),
                      ],
                      validator: (value) {
                        if (value.isEmpty) {
                          return '¿Cuanto compraremos?';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: MaterialButton(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      color: Colors.grey[300],
                      onPressed: () {
                        if (_formPedidoProductoKey.currentState.validate()) {
                          print('correct');
                          var _producto = {
                            "nombre": _tituloController.text,
                            "cantidad": int.parse(_cantidadController.text),
                          };
                          setState(() {
                            orderLines.add(_producto);
                            print('cor');
                          });
                          _tituloController.clear();
                          _cantidadController.clear();
                        } else {
                          print('incorrect');
                        }
                        print(orderLines);
                      },
                      child: Text('Agregar a la lista',
                          style: TextStyle(color: Colors.grey[600])),
                      disabledColor: Colors.grey[300],
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding:
                  const EdgeInsets.only(right: 8, left: 8, bottom: 15, top: 1),
              child: Container(
                color: Colors.grey[200],
                height: alto * 0.2,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        color: Colors.grey[300],
                        child: Row(
                          children: <Widget>[
                            Expanded(flex: 3, child: _tituloTabla("Productos")),
                            Expanded(flex: 2, child: _tituloTabla("Cantidad")),
                            Expanded(flex: 1, child: _tituloTabla("-"))
                          ],
                        ),
                      ),
                      for (var item in orderLines)
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0, bottom: 2),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 4,
                                  child: Text(
                                      item['nombre'].toString().toUpperCase())),
                              Expanded(flex: 1, child: _tituloTabla("\$")),
                              Expanded(
                                  flex: 1,
                                  child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 15.0),
                                      child: Text(
                                          "${item['cantidad'].toString()}",
                                          textAlign: TextAlign.right))),
                              Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        return showDialog<void>(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: Text(
                                                  'Eliminar: ${item['nombre'].toString().toUpperCase()}'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: Text(
                                                    'Cancelar',
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: Text('Eliminar'),
                                                  color: Color(0xffee6179),
                                                  onPressed: () async {
                                                    setState(() {
                                                      orderLines.remove(item);
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Icon(Icons.cancel,
                                          color:
                                              Color.fromRGBO(238, 97, 121, 0.7),
                                          size: 20))),
                            ],
                          ),
                        ),
                      orderLines.isNotEmpty
                          ? Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: <Widget>[
                                        //_pieTabla("Envío:   \$"),
                                        //_pieTabla("Comisión:   \$"),
                                        Text("SubTotal:  \$",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 60.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: <Widget>[
                                          //_pieTabla("25"),
                                          //_pieTabla("5"),
                                          Text(_pieSubtotal().toString(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Icon(Icons.pin_drop, color: Colors.grey),
                        ),
                        Text('Lugar de Compra:',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    _stados.isPunto("a")
                        ? iconDeleteRed("a", _stados)
                        : SizedBox(),
                  ],
                ),
                !_stados.isPunto("a")
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              showModalBottomSheet(
                                  elevation: alto * 0.8,
                                  backgroundColor: Color.fromRGBO(250, 0, 0, 1),
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return _elegirUbicacion(
                                        context, currentUser.uid, alto, "a");
                                  });
                            },
                            child: Text('Ubicacion Guardada',
                                style: TextStyle(color: Colors.grey[600])),
                            disabledColor: Colors.grey[300],
                          ),
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NuevaUbicacion('a'),
                                ),
                              );
                            },
                            disabledColor: Colors.grey[300],
                            child: Text("Ubicación Nueva",
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 1.0),
                        child: Text(_stados.getDirecciondelPunto("a"),
                            style: TextStyle(color: Colors.grey)),
                      )),
              ],
            ),
            Divider(
              color: Colors.grey,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Icon(Icons.pin_drop, color: Colors.grey),
                        ),
                        Text('Lugar de Entrega:',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    _stados.isPunto("b")
                        ? iconDeleteRed("b", _stados)
                        : SizedBox(),
                  ],
                ),
                !_stados.isPunto("b")
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              showModalBottomSheet(
                                  elevation: alto * 0.8,
                                  backgroundColor: Color.fromRGBO(250, 0, 0, 1),
                                  //shape:
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return _elegirUbicacion(
                                        context, currentUser.uid, alto, "b");
                                  });
                            },
                            child: Text('Ubicacion Guardada',
                                style: TextStyle(color: Colors.grey[600])),
                            disabledColor: Colors.grey[300],
                          ),
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              print('ubicacion ueva');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NuevaUbicacion("b"),
                                ),
                              );
                            },
                            disabledColor: Colors.grey[300],
                            child: Text("Ubicacion Nueva",
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 1.0),
                        child: Text(_stados.getDirecciondelPunto("b"),
                            style: TextStyle(color: Colors.grey)),
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _tipoChoose(double ancho, double alto) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(
              top: 30.0, left: 30.0, right: 30.0, bottom: 15.0),
          child: InkWell(
            onTap: () {
              setState(() {
                Provider.of<LoginState>(context, listen: false)
                    .setTipoPedido(1);
                Provider.of<LoginState>(context, listen: false).plusStep();
              });
            },
            child: Container(
              width: ancho,
              height: alto * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffdde9f7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      FontAwesomeIcons.moneyBill,
                      color: Color(0xff6e7e91),
                      size: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pago de Servicios',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff6e7e91),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
              top: 15.0, left: 30.0, right: 30.0, bottom: 30.0),
          child: InkWell(
            onTap: () {
              setState(() {
                Provider.of<LoginState>(context, listen: false)
                    .setTipoPedido(2);
                Provider.of<LoginState>(context, listen: false).plusStep();
              });
            },
            child: Container(
              width: ancho,
              height: alto * .3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffdde9f7),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.shopping_cart,
                      color: Color(0xff6e7e91),
                      size: 60,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pide Productos',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xff6e7e91),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _formServicio(double ancho, double alto, FirebaseUser currentUser,
      BuildContext context) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    return Padding(
      padding:
          const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
      child: Form(
        key: _formPedidoKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _tituloController,
                keyboardType: TextInputType.text,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Descrpción de Pago',
                  prefixIcon: Icon(Icons.edit),
                  //errorText: _validate ? 'Value Can\'t Be Empty' : null,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '¿Que Pago haremos?';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _datosController,
                keyboardType: TextInputType.text,
                maxLength: 50,
                decoration: InputDecoration(
                  labelText: 'Datos Para el Pago',
                  prefixIcon: Icon(Icons.person),
                  helperText:
                      'Número de Usuario, de cliente ó algun dato extra.',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '¿Seguro que no es necesario?';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextFormField(
                controller: _cantidadController,
                keyboardType: TextInputType.number,
                maxLength: 5,
                validator: (value) {
                  if (value.isEmpty) {
                    return '¿Cuánto Pagaremos?';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Cantidad a Pagar',
                  prefixIcon: Icon(Icons.monetization_on),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 10.0, left: 10.0),
                          child: Icon(Icons.pin_drop, color: Colors.grey),
                        ),
                        Text('Lugar a Pagar:',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                    _stados.isPunto("a")
                        ? iconDeleteRed("a", _stados)
                        : SizedBox(),
                  ],
                ),
                !_stados.isPunto("a")
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              showModalBottomSheet(
                                  elevation: alto * 0.8,
                                  backgroundColor: Color.fromRGBO(250, 0, 0, 1),
                                  //shape:
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return _elegirUbicacion(
                                        context, currentUser.uid, alto, "a");
                                  });
                            },
                            child: Text('Ubicacion Guardada',
                                style: TextStyle(color: Colors.grey[600])),
                            disabledColor: Colors.grey[300],
                          ),
                          MaterialButton(
                            color: Colors.grey[300],
                            onPressed: () {
                              print('ubicacion ueva');
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NuevaUbicacion("a"),
                                ),
                              );
                            },
                            disabledColor: Colors.grey[300],
                            child: Text("Ubicacion Nueva",
                                style: TextStyle(color: Colors.grey[600])),
                          )
                        ],
                      )
                    : Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 1.0),
                        child: Text(_stados.getDirecciondelPunto("a"),
                            style: TextStyle(color: Colors.grey)),
                      )),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Icon(Icons.pin_drop, color: Colors.grey),
                          ),
                          Text(
                            'Foto Recibo:',
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
            ),
          ],
        ),
      ),
    );
  }

  Future<String> _subirImagen(File image) async {
    StorageUploadTask _uploadTask;

    final FirebaseStorage _sto = LoginState().isStorage();
    String filePath = "recibos_clientes/${DateTime.now()}.png";
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

  Widget _buildItem(String item) {
    return new ListTile(
      title: new Text(item.toString()),
      leading: new Icon(Icons.map),
    );
  }

  Widget _esperaRepartidor(double ancho, double alto) {
    return Column(
      children: <Widget>[
        Text(
          '¡Tu Pedido esta registrado!',
          style: TextStyle(
              fontSize: 18, color: Colors.grey, fontStyle: FontStyle.italic),
        ),
        Image.asset('lib/assets/giphy.gif'),
        Text(
          'Buscando Repartidor...',
          style: TextStyle(fontSize: 20),
        ),
      ],
    );
  }

  Widget _modalTicket(double alto, double ancho, int subtotal) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              leading: Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(Icons.arrow_back_ios, color: Colors.grey))),
              title: Text("Mi Ticket", style: TextStyle(color: Colors.grey)),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _pieTabla("Subtotal:    \$"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: _pieTabla("Costo Servicio:    \$"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Total:    \$",
                            textAlign: TextAlign.right,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(right: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _pieTabla(subtotal.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: _pieTabla("25"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(_totalPedido(subtotal).toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.red[300],
                    textColor: Colors.red[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text('Cancelar'),
                    ),
                  ),
                  OutlineButton(
                    onPressed: () async {
                      final _stados =
                          Provider.of<LoginState>(context, listen: false);
                      final _user = _stados.currentUser();

                      var _pedidoregistrado = UserServices().newPedidoProductos(
                        orderLines,
                        subtotal,
                        _totalPedido(subtotal),
                        _user,
                      );

                      if (_pedidoregistrado) {
                        Navigator.of(context).pop();
                        Provider.of<LoginState>(context, listen: false)
                            .plusStep();
                      } else {
                        Navigator.of(context).pop();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Algo Pasó, Intentalo de Nuevo'),
                          backgroundColor: Color(0xffee6179),
                          duration: Duration(milliseconds: 2000),
                        ));
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text('Confirmar'),
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

  void _cleanDataPedido() {
    _tituloController.clear();
    _datosController.clear();
    _cantidadController.clear();
    _ubicacionController.clear();
    Provider.of<LoginState>(context, listen: false).setStepPedido(0);
  }

  Widget _elegirUbicacion(
      BuildContext context, String uid, double alto, String s) {
    return Container(
      height: alto * .5,
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance
            .collection('users')
            .document(uid)
            .collection("tiendas")
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Text('Loading...');
            default:
              return Stack(
                children: <Widget>[
                  Expanded(
                    child: ListView(
                      children: snapshot.data.documents
                          .map((DocumentSnapshot document) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              String _dire =
                                  "${document['calle']}, #${document['numero']}, ${document['localidad']}, ${document['ciudad']}";
                              double longi = document['longitud'];
                              double lati = document['latitud'];
                              Provider.of<LoginState>(context, listen: false)
                                  .setUbicacion(_dire, lati, longi, s);
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              color: Colors.grey[100],
                              child: new ListTile(
                                leading: Icon(Icons.store),
                                title: new Text(
                                  document['nombre'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54),
                                ),
                                subtitle: new Text(
                                    "${document['calle']}, #${document['numero']}, ${document['localidad']}, ${document['ciudad']}"),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Elige una ubicación',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              );
          }
        },
      ),
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

  Widget _listaNombres() {
    if (orderLines.isNotEmpty) {
      for (var item in orderLines) {
        print(item['nombre']);
        return Text(item['nombre']);
      }
    } else {
      return Text("Lista Vacia");
    }
  }

  Widget _tituloTabla(String s) {
    return Center(
      child: Text(
        s,
        style: TextStyle(fontSize: 13, color: Colors.grey),
      ),
    );
  }

  Widget _pieTabla(String s) {
    return Text(
      s,
      style: TextStyle(fontSize: 14, color: Colors.grey),
    );
  }

  int _pieSubtotal() {
    int _sub = 0;
    for (var item in orderLines) {
      setState(() {
        _sub = _sub + item['cantidad'];
      });
    }
    setState(() {
      subtotal = _sub;
    });
    return subtotal;
  }

  int _totalPedido(int subtotal) {
    return subtotal + 25;
  }
}
