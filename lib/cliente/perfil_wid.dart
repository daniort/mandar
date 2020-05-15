import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Perfil extends StatefulWidget {
  @override
  _PerfilState createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {
  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 10),
            width: ancho,
            height: alto * .09,
            child: Row(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Color(0xfff3f3f3),
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(color: Colors.black54)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 5.0, bottom: 5.0, left: 20.0, right: 20.0),
                    child: InkWell(
                      child: Container(
                        child: InkWell(
                          child: Text(
                            'Salir',
                            style: TextStyle(fontSize: 20),
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10, right: 20),
                    child: InkWell(
                      child: Container(
                        child: InkWell(
                          child: Icon(
                            Icons.edit,
                            size: 40,
                          ),
                          onTap: () {},
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  width: alto * .25,
                  height: alto * .25,
                  //margin: EdgeInsets.only(top: * 0.25),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 25)
                    ],
                  ),
                ),
                SizedBox(height: 40.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Juan José Peláez",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        child: Text(
                          "Numero de cuenta",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.0),
                      Container(
                        child: Text(
                          "Correo@correo.com",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
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
    );
  }
}
