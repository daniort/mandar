import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandadero/cliente/principal_wid.dart';
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
  TextEditingController _tituloController;
  TextEditingController _cantidadController;
  TextEditingController _ubicacionController;
  TextEditingController _cardNumberController;
  TextEditingController _cardHolderNameController;
  TextEditingController _cvvCodeController;
  TextEditingController _expiryDateController;
  GlobalKey _scaffoldKey = GlobalKey();
  Token _paymentToken;
  PaymentMethod _paymentMethod;
  String _error;
  final String _currentSecret = null; //set this yourself, e.g using curl
  PaymentIntentResult _paymentIntent;
  Source _source;
  ScrollController _controller = ScrollController();
  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  void initState() {
    _tituloController = TextEditingController();
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

  final _formPedidoKey = GlobalKey<FormState>();
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
              child: _firstForm(context, ancho, alto),
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
                            if (_tituloController.text.isNotEmpty) {
                              if (_cantidadController.text.isNotEmpty) {
                                Provider.of<LoginState>(context, listen: false)
                                    .plusStep();
                              } else {
                                print('no agregaste cantidad');
                              }
                            } else {
                              print('no agregaste descripcion');
                            }
                            break;
                          case 2:
                            Navigator.pop(context);
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
                          //color: Color(0xffee6179),
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

  _firstForm(BuildContext context, double ancho, double alto) {
    final _stados = Provider.of<LoginState>(context, listen: true);
    switch (_stados.isStepPedido()) {
      case 0:
        return _tipoChoose(ancho, alto);
        break;
      case 1:
        if (_stados.isTipoPedido() == 1) {
          return _formServicio();
        }
        //if (_stados.isTipo() == 2) {
        //return _formProducto();
        //}
        break;
      case 2:
        final _user =
            Provider.of<LoginState>(context, listen: false).currentUser();
        UserServices().newPedidoPagoServicios(
            _tituloController.text,
            _cantidadController.text,
            _ubicacionController.text,
            "nada de datos",
            _user);
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
                Provider.of<LoginState>(context, listen: false)
                    .plusStep();
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

  Widget _formServicio() {
    return Padding(
      padding:
          const EdgeInsets.only(top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
      child: Form(
        key: _formPedidoKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                  controller: _tituloController,
                  keyboardType: TextInputType.text,
                  maxLength: 50,
                  decoration: InputDecoration(
                      labelText: 'Descrpción de Pago',
                      prefixIcon: Icon(Icons.edit))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  maxLength: 5,
                  decoration: InputDecoration(
                      labelText: 'Cantidad a Pagar',
                      prefixIcon: Icon(Icons.monetization_on))),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextField(
                controller: _ubicacionController,
                keyboardType: TextInputType.text,
                maxLength: 50,
                decoration: InputDecoration(
                    helperText: 'Si lo dejas vacio, el Rapartidor elige.',
                    labelText: 'Lugar a Pagar',
                    prefixIcon: Icon(Icons.pin_drop)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: RaisedButton(
                        splashColor: Color(0xffee6179),
                        onPressed: () {
                          print('tomar foto');
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 8.0, bottom: 0.0),
                                child: Icon(Icons.photo, color: Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Tomar Foto a Recibo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.grey)),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(20, 20, 20, 0.2),
                              width: 5.0),
                        ),
                        child: Image.asset(
                          'lib/assets/error.png',
                          width: 100.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
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
                  _source = source;
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
}
