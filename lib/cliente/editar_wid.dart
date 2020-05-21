import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mandadero/Router/strings.dart';

class EditarCliente extends StatefulWidget {
  @override
  _EditarClienteState createState() => _EditarClienteState();
}

class _EditarClienteState extends State<EditarCliente> {
  TextEditingController _emailController;
  TextEditingController _direccionController;
  TextEditingController _nameController;
  TextEditingController _cardController;

  void initState() {
    _direccionController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _cardController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                          padding: const EdgeInsets.only(top: 12.0),
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
                                icon:
                                    Icon(Icons.email, color: Color(0xff11151C)),
                                labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _direccionController,
                            maxLength: 50,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.home, color: Color(0xff11151C)),
                                labelText: 'Direccion'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _direccionController,
                            maxLength: 50,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon:
                                    Icon(Icons.home, color: Color(0xff11151C)),
                                labelText:
                                    'Agregar etiqueta (p.ej. color de casa)'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: TextField(
                            controller: _cardController,
                            maxLength: 16,
                            cursorColor: Color(0xff11151C),
                            decoration: InputDecoration(
                                icon: Icon(Icons.credit_card,
                                    color: Color(0xff11151C)),
                                labelText: 'Numero de Tarjeta'),
                            autocorrect: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 2.0, left: 15.0, right: 15.0, bottom: 2.0),
                          child: Row(
                            children: <Widget>[
                              Container(
                                height: 40,
                                width: 100,
                                child: TextField(
                                  controller: _cardController,
                                  maxLength: 2,
                                  cursorColor: Color(0xff11151C),
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.credit_card,
                                          color: Color(0xff11151C)),
                                      labelText: 'Mes'),
                                  autocorrect: false,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 40,
                                width: 100,
                                child: TextField(
                                  controller: _cardController,
                                  maxLength: 2,
                                  cursorColor: Color(0xff11151C),
                                  decoration: InputDecoration(
                                      icon: Icon(Icons.credit_card,
                                          color: Color(0xff11151C)),
                                      labelText: 'Año'),
                                  autocorrect: false,
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
                                  Navigator.pushNamed(
                                      context, perfilclienteRoute);
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
