import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandadero/cliente/nueva_ubi.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/services/payment-service.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';
import 'package:stripe_payment/stripe_payment.dart';

class NuevoPedido extends StatefulWidget {
  @override
  _NuevoPedidoState createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _tituloController;
  TextEditingController _datosController;
  TextEditingController _cantidadController;
  TextEditingController _ubicacionController;

  TextEditingController _cardNumberController;
  TextEditingController _cardHolderNameController;
  TextEditingController _cvvCodeController;
  TextEditingController _expiryDateController;

  bool dir_elegida = false;
  String direccion = "";
  double longitud;
  double latitud;

  Token _paymentToken;
  PaymentMethod _paymentMethod;

  final String _currentSecret = null; //set this yourself, e.g using curl

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );
  final _formPedidoKey = GlobalKey<FormState>();
  String filePath = "recibos_clientes/${DateTime.now()}.png";
  StorageUploadTask _uploadTask;
  final ImagePicker picker = ImagePicker();
  File _image;
  final FirebaseStorage _sto = LoginState().isStorage();

  void initState() {
    _tituloController = TextEditingController();
    _datosController = TextEditingController();
    _cantidadController = TextEditingController();
    _ubicacionController = TextEditingController();

    _expiryDateController = TextEditingController();
    _cardNumberController = TextEditingController();
    _cardHolderNameController = TextEditingController();
    _cvvCodeController = TextEditingController();
    super.initState();
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_aSaULNS8cJU6Tvo20VAXy6rp",
        merchantId: "Test",
        androidPayMode: 'test'));
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
                            if (_formPedidoKey.currentState.validate()) {
                              print('valido, amonos');
                              showModalBottomSheet(
                                  elevation: alto * 0.35,
                                  backgroundColor: Color.fromRGBO(0, 0, 0, 0.1),
                                  context: context,
                                  builder: (BuildContext context) {
                                    return _modalTicket(alto, ancho);
                                  });
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
        //if (_stados.isTipo() == 2) {
        //return _formProducto();
        //}
        break;
      case 2:
        print('Paso ${_stados.isStepPedido()}');
        return _esperaRepartidor(ancho, alto);
        break;
      case 3:
        print('Paso ${_stados.isStepPedido()}');
        return _pagoChoose(ancho, alto);
        break;
      default:
    }
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
                //print(DateTime.now().month);
                print(DateTime.now().minute);
                //Provider.of<LoginState>(context, listen: false).setTipo(2);
                //Provider.of<LoginState>(context, listen: false).setStep(1);
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
                    _stados.isdireccion()
                        ? Padding(
                            padding:
                                const EdgeInsets.only(right: 10.0, left: 10.0),
                            child: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _stados.limpiarUbicacion();
                              },
                            ))
                        : SizedBox(),
                  ],
                ),
                !_stados.isdireccion()
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
                                        context, currentUser.uid, alto);
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
                                  builder: (context) => NuevaUbicacion(),
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
                        child: Text(_stados.direccion1,
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
    print('vamos a intrar al try');
    try {
      print('dentro del try');
      setState(() {
        _uploadTask = _sto.ref().child(filePath).putFile(_image);
      });
      // String url = 'null';
      //var dowurl;
      var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();
      print('acabando de subir la imagen');
      return url;
    } catch (e) {
      return 'null';
    }
  }

  Widget _buildItem(String item) {
    return new ListTile(
      title: new Text(item.toString()),
      //subtitle: new Text('Capital: ${item.capital}'),
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

  Widget _pagoCard(double ancho, double alto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 300.0),
        child: Column(
          children: <Widget>[
            Container(
              width: ancho * .8,
              child: CreditCardWidget(
                cardNumber: _cardNumberController.text,
                expiryDate: _expiryDateController.text,
                cardHolderName: _cardHolderNameController.text,
                cvvCode: _cvvCodeController.text,
                cardBgColor: Color(0xff0a2342),
                height: alto * .20,
                textStyle: TextStyle(
                  color: Color(0xfff7f0f0),
                ),
                width: MediaQuery.of(context).size.width,
                animationDuration: Duration(milliseconds: 1000),
                showBackView: false,
                //showBackView: Provider.of<LoginState>(context, listen: true)
                //.isCVVFocus(), //true when you want to show cvv(back) view
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0),
              child: TextField(
                  onSubmitted: (Provider.of<LoginState>(context, listen: false)
                      .setCVVState(false)),
                  controller: _cardNumberController,
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  decoration: InputDecoration(
                      labelText: 'Número de Tarjeta',
                      prefixIcon: Icon(Icons.credit_card))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0),
              child: TextField(
                  onSubmitted: (Provider.of<LoginState>(context, listen: false)
                      .setCVVState(false)),
                  controller: _cardHolderNameController,
                  keyboardType: TextInputType.text,
                  maxLength: 40,
                  decoration: InputDecoration(
                      labelText: 'Nombre del Titular',
                      prefixIcon: Icon(Icons.people))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0),
              child: TextField(
                  expands: false,
                  onSubmitted: (Provider.of<LoginState>(context, listen: false)
                      .setCVVState(false)),
                  controller: _expiryDateController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                      labelText: 'Fecha de Expiración',
                      prefixIcon: Icon(Icons.date_range))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0),
              child: TextField(
                  expands: false,
                  onSubmitted: (Provider.of<LoginState>(context, listen: false)
                      .setCVVState(true)),
                  controller: _cvvCodeController,
                  keyboardType: TextInputType.text,
                  maxLength: 3,
                  decoration: InputDecoration(
                      labelText: 'CVV', prefixIcon: Icon(Icons.edit))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pagoChoose(double ancho, double alto) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 300.0),
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Create Source"),
              onPressed: () {
                StripePayment.createSourceWithParams(SourceParams(
                  type: 'ideal',
                  amount: 1099,
                  currency: 'eur',
                  returnURL: 'example://stripe-redirect',
                )).then((source) {
                  print('Received ${source.sourceId}');
                  //_scaffoldKey.currentState.showSnackBar(
                  //  SnackBar(content: Text('Received ${source.sourceId}')));
                  //setState(() {
                  //_source = source;
                  //});
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Token with Card Form"),
              onPressed: () {
                StripePayment.paymentRequestWithCardForm(
                        CardFormPaymentRequest())
                    .then((paymentMethod) {
                  print('Received ${paymentMethod.id}');
                  //_scaffoldKey.currentState.showSnackBar(
                  ////  SnackBar(content: Text('Received ${paymentMethod.id}')));
                  //setState(() {
                  //                    _paymentMethod = paymentMethod;
                  //                });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Token with Card"),
              onPressed: () {
                StripePayment.createTokenWithCard(
                  testCard,
                ).then((token) {
                  print('Received ${token.tokenId}');
                  //_scaffoldKey.currentState.showSnackBar(
                  //  SnackBar(content: Text('Received ${token.tokenId}')));
                  //setState(() {
                  //                    _paymentToken = token;
                  //                });
                }).catchError(setError);
              },
            ),
            Divider(),
            RaisedButton(
              child: Text("Create Payment Method with Card"),
              onPressed: () {
                StripePayment.createPaymentMethod(
                  PaymentMethodRequest(
                    card: testCard,
                  ),
                ).then((paymentMethod) {
                  print('Received ${paymentMethod.id}');
                  //_scaffoldKey.currentState.showSnackBar(
                  //SnackBar(content: Text('Received ${paymentMethod.id}')));
                  //setState(() {
                  //                    _paymentMethod = paymentMethod;
                  //                });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Create Payment Method with existing token"),
              onPressed: _paymentToken == null
                  ? null
                  : () {
                      StripePayment.createPaymentMethod(
                        PaymentMethodRequest(
                          card: CreditCard(
                            token: _paymentToken.tokenId,
                          ),
                        ),
                      ).then((paymentMethod) {
                        print('Received ');
                        //_scaffoldKey.currentState.showSnackBar(SnackBar(
                        //  content: Text('Received ${paymentMethod.id}')));
                        //setState(() {
                        //                          _paymentMethod = paymentMethod;
                        //});
                      }).catchError(setError);
                    },
            ),
            Divider(),
            RaisedButton(
              child: Text("Confirm Payment Intent"),
              onPressed: _paymentMethod == null || _currentSecret == null
                  ? null
                  : () {
                      StripePayment.confirmPaymentIntent(
                        PaymentIntent(
                          clientSecret: _currentSecret,
                          paymentMethodId: _paymentMethod.id,
                        ),
                      ).then((paymentIntent) {
                        print('Received ');
                        //_scaffoldKey.currentState.showSnackBar(SnackBar(
                        //content: Text(
                        //'Received ${paymentIntent.paymentIntentId}')));
                        //setState(() {
                        //                          _paymentIntent = paymentIntent;
                        //                      });
                      }).catchError(setError);
                    },
            ),
            RaisedButton(
              child: Text("Authenticate Payment Intent"),
              onPressed: _currentSecret == null
                  ? null
                  : () {
                      StripePayment.authenticatePaymentIntent(
                              clientSecret: _currentSecret)
                          .then((paymentIntent) {
                        //_scaffoldKey.currentState.showSnackBar(SnackBar(
                        //content: Text(
                        //  'Received ${paymentIntent.paymentIntentId}')));
                        //setState(() {
                        //                          _paymentIntent = paymentIntent;
                        //                      });
                      }).catchError(setError);
                    },
            ),
            RaisedButton(
              child: Text("Native payment"),
              onPressed: () {
                StripePayment.paymentRequestWithNativePay(
                  androidPayOptions: AndroidPayPaymentRequest(
                    totalPrice: "1.20",
                    currencyCode: "EUR",
                  ),
                  applePayOptions: ApplePayPaymentOptions(
                    countryCode: 'DE',
                    currencyCode: 'EUR',
                    items: [
                      ApplePayItem(
                        label: 'Test',
                        amount: '13',
                      )
                    ],
                  ),
                ).then((token) {
                  setState(() {
                    //_scaffoldKey.currentState.showSnackBar(
                    //  SnackBar(content: Text('Received ${token.tokenId}')));
                    //_paymentToken = token;
                  });
                }).catchError(setError);
              },
            ),
            RaisedButton(
              child: Text("Complete Native Payment"),
              onPressed: () {
                StripePayment.completeNativePayRequest().then((_) {
                  //_scaffoldKey.currentState.showSnackBar(
                  //  SnackBar(content: Text('Completed successfully')));
                }).catchError(setError);
              },
            ),
          ],
        ),
      ),
    );
  }

  payViaNewCard() async {
    //ProgressDialog dialog = new ProgressDialog(context);
    //dialog.style(message: 'Please wait...');
    //await dialog.show();

    var response =
        await StripeService.payWithNewCard(amount: '15000', currency: 'USD');
    //await dialog.hide();
    //Scaffold.of(context).showSnackBar(SnackBar(

    //content: Text(response.message),
    //duration:
    //  new Duration(milliseconds: response.success == true ? 1200 : 3000),
    //));
  }

  setError() {
    print('set error dice');
  }

  Widget _modalTicket(double alto, double ancho) {
    return Container(
      //height: alto * 0.35,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
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
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Cantidad a Pagar:   ",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                            Icon(
                              Icons.attach_money,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Costo Servicio:   ",
                              style:
                                  TextStyle(fontSize: 16.0, color: Colors.grey),
                            ),
                            Icon(
                              Icons.attach_money,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Total:   ",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey),
                            ),
                            Icon(
                              Icons.attach_money,
                              size: 15,
                              color: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(_cantidadController.value.text),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("20"),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("520"),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[],
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
                      print('ticket cancelado');
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

                      var _urlim = await _subirImagen(_image);

                      var _pedidoregistrado = UserServices()
                          .newPedidoPagoServicios(
                              _tituloController.text,
                              _cantidadController.text,
                              _ubicacionController.text,
                              _datosController.text,
                              _user,
                              _urlim,
                              _stados.lati1,
                              _stados.longi1);

                      if (_pedidoregistrado) {
                        Navigator.of(context).pop();
                        Provider.of<LoginState>(context, listen: false)
                            .plusStep();
                      } else {
                        Navigator.of(context).pop();
                        _scaffoldKey.currentState.showSnackBar(SnackBar(
                          content: Text('Algo Pasó, Intentalo de Nuevo'),
                          backgroundColor: Color(0xffee6179),
                          duration: Duration(milliseconds: 3000),
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

  Widget _elegirUbicacion(BuildContext context, String uid, double alto) {
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
                                  .setUbicacionNueva(_dire, lati, longi);
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
}
