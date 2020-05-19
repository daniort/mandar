import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';

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
            decoration: BoxDecoration(color: Color(0xff36827f)),
            child: Column(
              children: <Widget>[
                SizedBox(height: alto * .02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: Icon(
                          Icons.exit_to_app,
                          size: 30,
                        ),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, loginClienteRoute);
                      },
                    ),
                    SizedBox(width: ancho * .03),
                  ],
                ),
                Container(
                  width: alto * .3,
                  height: alto * .3,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100),
                    boxShadow: [
                      BoxShadow(color: Colors.white10, blurRadius: 25)
                    ],
                  ),
                ),
                SizedBox(height: alto * .015),
                Container(
                  //alignment: Alignment.topCenter,
                  child: Text(
                    "Juan José Peláez",
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, editarCliente);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: Color(0xffbdd4d3),
                        ),
                        child: Center(
                          child: Text(
                            'Editar Perfil',
                            //textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: ancho * 0.2,
                    )
                  ],
                ),
                SizedBox(height: alto * .01),
              ],
            ),
          ),
          SizedBox(
            height: alto * .03,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 25),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xff36827f),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.home,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Calle Guerrero No. 15',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: alto * .03,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 25),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xff36827f),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.email,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'juanpelaez@gmail.com',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
          SizedBox(
            height: alto * .03,
          ),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 25),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                    color: Color(0xff36827f),
                    borderRadius: BorderRadius.circular(10)),
                child: Icon(
                  Icons.credit_card,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  '1254864581256324',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
