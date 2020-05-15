import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mandadero/widget/text_input.dart';

class Editar extends StatefulWidget {
  @override
  _EditarState createState() => _EditarState();
}

class _EditarState extends State<Editar> {
  final _formkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
  }

  _submit() {
    _formkey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: size.width,
          height: size.height,
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Container(
                  width: size.width,
                  height: size.height,
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: 300, minWidth: 300),
                              child: Form(
                                key: _formkey,
                                child: Column(
                                  children: <Widget>[
                                    InputText(
                                      label: "NOMBRE(S)",
                                      inputType: TextInputType.text,
                                      validator: (String text) {
                                        if (text.isNotEmpty &&
                                            text.length > 5 &&
                                            text.length <= 20) {
                                          return null;
                                        }
                                        return "Nombre Invalido";
                                      },
                                    ),
                                    InputText(label: "APELLIDOS"),
                                    InputText(
                                        label: "EMAIL ADDRESS",
                                        inputType: TextInputType.emailAddress,
                                        validator: (String text) {
                                          if (text.contains("@")) {
                                            return null;
                                          }
                                          return "Invalid Email";
                                        }),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    InputText(
                                      label: "PASSWORD",
                                      isSecure: true,
                                      validator: (String text) {
                                        if (text.isNotEmpty &&
                                            text.length > 5) {
                                          return null;
                                        }
                                        return "Invalid Password";
                                      },
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            ConstrainedBox(
                              constraints:
                                  BoxConstraints(maxWidth: 300, minWidth: 300),
                              child: CupertinoButton(
                                padding: EdgeInsets.symmetric(vertical: 14),
                                borderRadius: BorderRadius.circular(4),
                                child: Text(
                                  "Guardar Informacion",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () => _submit(),
                                color: Colors.pink,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
