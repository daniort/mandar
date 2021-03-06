import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/screens/regsitro.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    Provider.of<LoginState>(context, listen: false).logout();
                  },
                )
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(top: 25, bottom: 15, left: 15, right: 15),
              child: Form(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        child: Center(
                          child: Text(
                            'Logeate',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color(0xff11151C), fontSize: 27),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: InkWell(
                        child: Container(
                          width: ancho * 0.7,
                          height: alto * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                              child: Text(
                            'Entra y has tus pedidos!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.normal),
                          )),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Container(
                        width: ancho * 0.9,
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey)),
                        ),
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
                            icon: Icon(Icons.email, color: Color(0xff11151C)),
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        autocorrect: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                      child: TextField(
                        controller: _passwordController,
                        maxLength: 10,
                        cursorColor: Color(0xff11151C),
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock, color: Color(0xff11151C)),
                            labelText: 'Contraseña'),
                        obscureText: true,
                        autocorrect: false,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 4.0, left: 20.0, right: 20.0),
                      child: InkWell(
                        onTap: () async {
                          Provider.of<LoginState>(context, listen: false)
                              .loginWithEmailAndPass(_emailController.text,
                                  _passwordController.text);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color(0xff464d77),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text(
                              'Entrar',
                              style: TextStyle(
                                color: Color(0xffffffff),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: ancho * 0.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                            child: Text(
                          'o entra con:',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.normal),
                        )),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Provider.of<LoginState>(context, listen: false)
                                .socialLogin(2);
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(0xff3b5998),
                                  borderRadius: BorderRadius.circular(90)),
                              width: 40,
                              height: 40,
                              child: Icon(FontAwesomeIcons.facebookF,
                                  size: 20, color: Color(0xfff6f4f3))),
                        ),
                        SizedBox(
                          width: ancho * 0.01,
                        ),
                        InkWell(
                          onTap: () async {
                            Provider.of<LoginState>(context, listen: false)
                                .socialLogin(3);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffee6179),
                                borderRadius: BorderRadius.circular(90)),
                            width: 40,
                            height: 40,
                            child: Icon(FontAwesomeIcons.google,
                                size: 20, color: Color(0xfff6f4f3)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: alto * 0.02,
                    ),
                    Container(
                      width: ancho * 0.7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                          child: Text(
                        '¿No tienes Cuenta?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.normal),
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        //Navigator.pushNamed(context, signRoute);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Sign()));
                      },
                      child: Container(
                        width: ancho * 0.7,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                            child: Text(
                          'Registrate Aquí',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Provider.of<LoginState>(context, listen: true)
                              .isLoading()
                          ? CircularProgressIndicator()
                          : SizedBox(),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Provider.of<LoginState>(context, listen: true)
                              .isError()
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                FaIcon(
                                  FontAwesomeIcons.exclamationCircle,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Text('Algo pasó,\nintenta nuevamente',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15))
                              ],
                            )
                          : SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(100.0)),
                    color: Color(0xffdde9f7),
                    //borderRadius: BorderRadius.circular(80.0)),
                  )),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(topLeft: Radius.circular(100.0)),
                    color: Color(0xffdde9f7),
                    //borderRadius: BorderRadius.circular(80.0)),
                  )),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomLeft: Radius.circular(100.0)),
                    color: Color(0xffdde9f7),
                    //borderRadius: BorderRadius.circular(80.0)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
