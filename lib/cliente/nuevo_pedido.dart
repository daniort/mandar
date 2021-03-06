import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandadero/cliente/nueva_ubi.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/services/widgets.dart';
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

  int subtotal = 0;
  double costoServicio = 0.0;
  File _image;
  List orderLines = <Map>[];
  List puntos = [];
  List distancias = [];
  bool destino = false;
  final ImagePicker picker = ImagePicker();
  final _formPedidoKey = GlobalKey<FormState>();
  final _formPedidoProductoKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  void initState() {
    _tituloController = TextEditingController();
    _datosController = TextEditingController();
    _cantidadController = TextEditingController();
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
      appBar: AppBar(
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _state.isAdvertencia()
                ? Icon(FontAwesomeIcons.exclamationCircle,
                    color: Color(0xffec506b))
                : SizedBox(),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: _state.isLoading()
                ? Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Color(0xfff6f9ff),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
                    ),
                  )
                : SizedBox(),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Color(0xfff6f9ff),
        elevation: 0.0,
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    '¿Que Necesitas?',
                    style: GoogleFonts.courgette(
                      fontSize: 30,
                      color: Color(0xff292f36),
                    ),
                  ),
                ),
                Divider(
                  height: 2,
                ),
                _firstForm(context),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: InkWell(
                    onTap: () {
                      switch (_state.isTipoPedido()) {
                        case 1:
                          switch (_state.isStepPedido()) {
                            case 0:
                              Navigator.of(context).pop();
                              break;
                            case 1:
                              Provider.of<LoginState>(context, listen: false)
                                  .backStep();
                              break;
                            case 2:
                              Navigator.of(context).pop();
                              break;
                            default:
                          }
                          break;
                        case 2:
                          switch (_state.isStepPedido()) {
                            case 0:
                              Navigator.of(context).pop();
                              break;
                            case 1:
                              Provider.of<LoginState>(context, listen: false)
                                  .backStep();
                              _state.loading(false);
                              break;
                            case 2:
                              Provider.of<LoginState>(context, listen: false)
                                  .backStep();
                              _state.loading(false);
                              break;
                            default:
                          }
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
                      switch (_state.isTipoPedido()) {
                        case 1:
                          switch (_state.isStepPedido()) {
                            case 1:
                              if (_formPedidoKey.currentState.validate() &&
                                  _state.isPunto('a')) {
                                showModalBottomSheet(
                                    elevation: alto * 0.35,
                                    backgroundColor:
                                        Color.fromRGBO(0, 0, 0, 0.1),
                                    context: context,
                                    builder: (BuildContext context) {
                                      return _modalTicket(alto, ancho,
                                          int.parse(_cantidadController.text));
                                    });
                              }
                              break;
                            case 2:
                              Navigator.of(context).pop();
                              break;
                            default:
                          }
                          break;

                        case 2:
                          switch (_state.isStepPedido()) {
                            case 1:
                              if (orderLines.isNotEmpty) {
                                _state.plusStep();
                              } else {
                                _state.salioAdvertencia();
                              }
                              break;
                            case 2:
                              if (orderLines.isNotEmpty &&
                                  _state.isPunto("b")) {
                                _calcularCostedelServicio();
                                if (costoServicio >= 1.0) {
                                  showModalBottomSheet(
                                      elevation: alto * 0.7,
                                      backgroundColor:
                                          Color.fromRGBO(0, 0, 0, 0.1),
                                      context: context,
                                      builder: (BuildContext context) {
                                        return _modalListaPedidosConfirmar(
                                            alto, ancho, context);
                                      });
                                } else {
                                  _calcularCostedelServicio();
                                  _state.loading(true);
                                }
                              } else {
                                print("aqui");
                                _state.salioAdvertencia();
                              }
                              break;
                            default:
                          }

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
                            child: _state.isAdvertencia()
                                ? Icon(Icons.cancel, color: Colors.white)
                                : _state.isLoading()
                                    ? CircularProgressIndicator(
                                        backgroundColor: Color(0xffec506b),
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      )
                                    : Icon(
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
    );
  }

  _firstForm(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    final _stados = Provider.of<LoginState>(context, listen: true);
    switch (_stados.isStepPedido()) {
      case 0:
        return _tipoChoose(ancho, alto);
        break;
      case 1:
        if (_stados.isTipoPedido() == 1) {
          return _formServicio(ancho, alto, _stados.currentUser(), context);
        }
        if (_stados.isTipoPedido() == 2) {
          return _formProducto(ancho, alto, _stados.currentUser(), context);
        }
        break;
      case 2:
        print('Paso ${_stados.isStepPedido()}');
        if (_stados.isTipoPedido() == 1) {
          return esperaRepartidor(ancho, alto);
        }
        if (_stados.isTipoPedido() == 2) {
          return _ubicacionEntrega(alto, ancho);
        }

        break;
      case 3:
        print('Paso ${_stados.isStepPedido()}');
        //return _pagoChoose(ancho, alto);
        break;
      default:
    }
  }

  Widget _formProducto(double ancho, double alto, FirebaseUser currentUser,
      BuildContext context) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.only(
          top: 2.0, left: 15.0, right: 15.0, bottom: 100.0),
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
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return '¿Que Compra haremos?';
                  }
                  return null;
                },
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: Icon(Icons.pin_drop, color: Colors.grey),
                          ),
                          Text('¿Donde lo Compramos?',
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                      _stados.isPunto("x")
                          ? iconDeleteRedDos("x", _stados)
                          : SizedBox(),
                    ],
                  ),
                ),
                !_stados.isPunto("x")
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
                                        context, currentUser.uid, alto, "x");
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
                                    builder: (context) =>
                                        NuevaUbicacion(data: 'x')),
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
                        child: Text(_stados.getDirecciondelPunto("x")['label'],
                            style: TextStyle(color: Colors.grey)),
                      )),
              ],
            ),
            Divider(
              color: Colors.grey,
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
                          var _producto = {
                            "nombre": _tituloController.text,
                            "cantidad": int.parse(_cantidadController.text),
                            "punto": _stados.getDirecciondelPunto("x"),
                            "distancia": 0.0,
                            "comprado": false,
                          };
                          setState(() {
                            orderLines.add(_producto);
                          });
                          _tituloController.clear();
                          _cantidadController.clear();
                        } else {
                          print('incorrect');
                        }
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
                  const EdgeInsets.only(right: 8, left: 8, bottom: 15, top: 10),
              child: Container(
                color: Colors.grey[200],
                height: alto * 0.25,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                        color: Colors.grey[300],
                        child: Row(
                          children: <Widget>[
                            Expanded(flex: 3, child: tituloTabla("Productos")),
                            Expanded(flex: 2, child: tituloTabla("Cantidad")),
                            Expanded(flex: 1, child: tituloTabla("-"))
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
                              Expanded(flex: 1, child: tituloTabla("\$")),
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
                        ? iconDeleteRedDos("a", _stados)
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      NuevaUbicacion(data: 'a'),
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
                        child: Text(_stados.getDirecciondelPunto("a")['label'],
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

  Widget _ubicacionEntrega(double alto, double ancho) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Icon(Icons.pin_drop, color: Colors.grey),
                  ),
                  Text('Lugar de Entrega:',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
              _stados.isPunto("b")
                  ? iconDeleteRedDos("b", _stados)
                  : SizedBox(),
            ],
          ),
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
                                context, _stados.currentUser().uid, alto, "b");
                          });
                    },
                    child: Text('Ubicacion Guardada',
                        style: TextStyle(color: Colors.grey[600])),
                    disabledColor: Colors.grey[300],
                  ),
                  MaterialButton(
                    color: Colors.grey[300],
                    onPressed: () {
                      String _tip = 'b';
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NuevaUbicacion(data: _tip),
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
                child: Text(_stados.getDirecciondelPunto("b")['label'],
                    style: TextStyle(color: Colors.grey)),
              )),
      ],
    );
  }

  Widget _modalTicket(double alto, double ancho, int subtot) {
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
                        child: pieTabla("Subtotal:    \$"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: pieTabla("Costo Servicio:    \$"),
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
                          child: pieTabla(subtotal.toString()),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: pieTabla("25"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(_totalPedido(subtot).toString(),
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
                      bool _pedidoregistrado = false;

                      if (_stados.isTipoPedido() == 1) {
                        String _url = await _subirImagen(_image);
                        _pedidoregistrado = UserServices()
                            .newPedidoPagoServicios(
                                _tituloController.text,
                                _datosController.text,
                                int.parse(_cantidadController.text),
                                _totalPedido(subtot),
                                _stados.currentUser(),
                                _url,
                                _stados.getDirecciondelPunto('a'));
                      }

                      if (_pedidoregistrado) {
                        //_formPedidoKey.currentState.reset();
                        //_formPedidoProductoKey.currentState.reset();
                        _stados.plusStep();
                        _stados.setStepPedido(0);
                        Navigator.of(context).pop();
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

  Widget _modalListaPedidosConfirmar(
      double alto, double ancho, BuildContext context) {
    return Container(
      height: alto * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var item in puntos)
              Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text("Punto de Compra:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.grey)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 2.0, bottom: 4.0, left: 10, right: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Icon(Icons.pin_drop),
                        ),
                        Expanded(
                          flex: 9,
                          child: Text(item['label'],
                              textAlign: TextAlign.left,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  for (var item2 in orderLines)
                    if (item['label'] == item2['punto']["label"])
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 4.0, bottom: 4.0, left: 20, right: 30),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 2,
                              child: pieTabla(
                                  item2['nombre'].toString().toUpperCase()),
                            ),
                            Expanded(
                                flex: 1,
                                child: pieTablaRigth(
                                    "\$ ${item2['cantidad'].toString()}")),
                          ],
                        ),
                      ),
                ],
              ),
            Text(
              "Punto de Entrega:",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey[800]),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 2.0, bottom: 4.0, left: 10, right: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(Icons.person_pin_circle),
                  ),
                  Expanded(
                    flex: 9,
                    child: Text(
                        "${Provider.of<LoginState>(context, listen: true).getDirecciondelPunto('b')['label']}",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, left: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: pieTablaRigth("Total Pedido:  \$"),
                  ),
                  Expanded(
                    flex: 1,
                    child: pieTablaRigth(subtotal.toString()),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 4.0, bottom: 4.0, left: 20, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: pieTablaRigth("Costo del Servicio:  \$"),
                  ),
                  Expanded(
                    flex: 1,
                    child: pieTablaRigth(redondear(costoServicio).toString()),
                  )
                ],
              ),
            ),
            Divider(
              color: Colors.grey,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OutlineButton(
                    splashColor: Colors.red[200],
                    textColor: Colors.red[300],
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30.0),
                      child: Text('Cancelar'),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: RaisedButton(
                        onPressed: () async {
                          final _stados =
                              Provider.of<LoginState>(context, listen: false);
                          bool _pedidoregistrado = false;
                          final _destino = _stados.getDirecciondelPunto('b');
                          _pedidoregistrado = await UserServices()
                              .newPedidoProductos(
                                  await _llenarDistancias(
                                      orderLines,
                                      _destino["latitud"],
                                      _destino['longitud']),
                                  subtotal,
                                  costoServicio,
                                  _stados.currentUser(),
                                  _destino,
                                  350.3);

                          if (_pedidoregistrado) {
                            //_formPedidoKey.currentState.reset();
                            //_formPedidoProductoKey.currentState.reset();
                            _stados.plusStep();
                            _stados.setStepPedido(0);
                            Navigator.of(context).pop();
                            Navigator.of(context).pop();
                          } else {
                            Navigator.of(context).pop();
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              content: Text('Algo Pasó, Intentalo de Nuevo'),
                              backgroundColor: Color(0xffee6179),
                              duration: Duration(milliseconds: 2000),
                            ));
                          }
                        },
                        child: Text('Confirmar',
                            style: TextStyle(color: Colors.white)),
                        color: Colors.grey[900],
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

  _calcularCostedelServicio() {
    setState(() {
      double preCostoServicio = _porDestinos() + double.parse(_porCompra(subtotal));
      costoServicio =
          preCostoServicio + _comisionApp(preCostoServicio) + 2.50;
    });
  }

  Future<List> _llenarDistancias(
      List listaTemporal, double startLatitude, double startLongitude) async {
    List a = listaTemporal;
    for (var item in a) {
      final double endLatitude = item['punto']['latitud'];
      final double endLongitude = item['punto']['longitud'];
      item['distancia'] = await Geolocator().distanceBetween(
          startLatitude, startLongitude, endLatitude, endLongitude);
    }
    return listaTemporal;
  }

  int _posicionMenor(List li) {
    int _pos = 0;
    for (var i = 0; i < li.length; i++) {
      if (i == 0) {
        _pos = i;
      } else {
        if (li[i]['distancia'] < li[_pos]['distancia']) {
          _pos = i;
        }
      }
    }
    return _pos;
  }

   _porCompra(int sub) {
    if (sub >= 1000) {
      return sub * 0.02;
    }
    if (sub >= 800 && sub <= 999) {
      return sub * 0.03;
    }
    if (sub >= 500 && sub <= 799) {
      return sub * 0.05;
    }
    if (sub >= 300 && sub <= 499) {
      return sub * 0.06;
    }
    if (sub >= 100 && sub <= 299) {
      return sub * 0.08;
    }
    if (sub >= 99) {
      return sub * 0.10;
    }
  }

   double _porDestinos() {
    int _destinos = rellenarDestinos().length;
    if (_destinos <= 2) return subtotal * 0.10;
    if (_destinos <= 4) return subtotal * 0.08;
    if (_destinos <= 6) return subtotal * 0.06;
    if (_destinos <= 8) return subtotal * 0.05;
    if (_destinos <= 10) return subtotal * 0.03;
    if (_destinos >= 11) return subtotal * 0.02;
  }

  _porDistancia() async {
    final destino = Provider.of<LoginState>(context, listen: false)
        .getDirecciondelPunto('b');
    double startLatitude = destino['latitud'];
    double startLongitude = destino['longitud'];
    List listaTemporal = orderLines;
    int posmin = 0;
    double disTotal = 0.0;

    for (var i = 0; i < orderLines.length + 1; i++) {
      listaTemporal =
          await _llenarDistancias(listaTemporal, startLatitude, startLongitude);
      posmin = _posicionMenor(listaTemporal);
      disTotal = disTotal + listaTemporal[posmin]['distancia'];
      startLatitude = listaTemporal[posmin]['punto']['latitud'];
      startLongitude = listaTemporal[posmin]['punto']['longitud'];
      listaTemporal.remove(posmin);
    }
    return disTotal;
  }

  rellenarDestinos() {
    puntos.clear();
    for (var item in orderLines) {
      var existe = false;
      if (puntos == null) {
        puntos.add(item['punto']);
      } else {
        for (var p in puntos) {
          if (p == item['punto']) {
            existe = true;
          }
        }
        if (!existe) {
          puntos.add(item['punto']);
        }
      }
    }
    return puntos;
  }

  num _comisionApp(double pre) {
    return pre * 0.029;
  }
}
