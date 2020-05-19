import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/state/loginstate.dart';

class NuevoPedido extends StatefulWidget {
  @override
  _NuevoPedidoState createState() => _NuevoPedidoState();
}

class _NuevoPedidoState extends State<NuevoPedido> {
  TextEditingController _emailController;
  TextEditingController _passwordController;
  TextEditingController _nameController;

  void initState() {
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                            'Registro',
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
                          width: MediaQuery.of(context).size.width * 0.7,
                          height: MediaQuery.of(context).size.height * 0.06,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                              child: Text(
                            'Con esta cuenta podras hacer pedidos o repartir pedidos cuando desees',
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
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          border: Border(top: BorderSide(color: Colors.grey)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15.0, left: 15.0, right: 15.0, bottom: 2.0),
                      child: TextField(
                        controller: _nameController,
                        maxLength: 30,
                        cursorColor: Color(0xff11151C),
                        decoration: InputDecoration(
                            icon: Icon(
                              Icons.person,
                              color: Color(0xff11151C),
                            ),
                            labelText: 'Nombre Completo'),
                        keyboardType: TextInputType.emailAddress,
                        inputFormatters: [
                          BlacklistingTextInputFormatter(RegExp("[0-9]")),
                        ],
                        //autovalidate: true,
                        autocorrect: false,
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
                          var uid = LoginState().signupEmail(
                              _emailController.text,
                              _passwordController.text,
                              _nameController.text);
                          if (uid.toString() != null) {
                            Navigator.pushNamed(context, loginClienteRoute);
                          } else {
                            print('error');
                          }
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Color(0xff36827f),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Center(
                            child: Text(
                              'Enviar Datos',
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
                    color: Color(0xffbdd4d3),
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
                    color: Color(0xffbdd4d3),
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
                    color: Color(0xffbdd4d3),
                    //borderRadius: BorderRadius.circular(80.0)),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
