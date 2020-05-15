import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class LoginCliente extends StatefulWidget {
  @override
  _LoginClienteState createState() => _LoginClienteState();
}

class _LoginClienteState extends State<LoginCliente> {
  TextEditingController _emailController;
  TextEditingController _passwordController;

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
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(15.0),
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
                          var uid = LoginState().loginEmail(
                            _emailController.text,
                            _passwordController.text,
                          );
                          if (uid.toString() != "null") {
                            Provider.of<LoginState>(context, listen: false)
                                .login();
                            Navigator.pop(context);
                          } else {
                            print('error');
                          }
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
                          onTap: () async {
                            
                                 var uid = LoginState().loginFB();
                            if (uid != null) {
                              Provider.of<LoginState>(context, listen: false)
                                  .login();
                              Navigator.pop(context);
                            } else {
                              print('error login facebokk');
                            }
                            //Provider.of<LoginState>(context, listen: false)
                              //  .login();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff3b5998),
                                borderRadius: BorderRadius.circular(90)),
                            width: 40,
                            height: 40,
                            child: Icon(FontAwesomeIcons.facebookF,
                                size: 20, color: Color(0xfff6f4f3)),
                          ),
                        ),
                        SizedBox(
                          width: ancho * 0.01,
                        ),
                        InkWell(
                          onTap: () async {
                            var uid = LoginState().loginGoogle();
                            if (uid != null) {
                              Provider.of<LoginState>(context, listen: false)
                                  .login();
                              Navigator.pop(context);
                            } else {
                              print('error login google');
                            }
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
                        Navigator.pushNamed(context, signRoute);
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
              alignment: Alignment.topLeft,
              child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(100.0)),
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
