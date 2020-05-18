import 'package:flutter/material.dart';

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
      child: Stack(
        alignment: Alignment.topRight,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(color: Colors.white),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    child: Text(
                      'REPARTIDOR',
                      style: TextStyle(fontSize: 30),
                    ),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 10, color: Colors.white),
                        bottom: BorderSide(width: 5, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(color: Color(0xffee6179)),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: alto * .3,
                        height: alto * .3,
                        //margin: EdgeInsets.only(top: * 0.25),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(color: Colors.white10, blurRadius: 25)
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Juan José Peláez",
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(fontSize: 28, color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 7.0),
                          InkWell(
                            child: Container(
                              width: ancho * .1,
                              height: ancho * .1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(100),
                                  color: Colors.white),
                              child: Icon(
                                Icons.more_vert,
                                size: 27,
                              ),
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
                SizedBox(
                  height: alto * .04,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color(0xffee6179),
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
                  height: alto * .04,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color(0xffee6179),
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
                  height: alto * .04,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 25),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Color(0xffee6179),
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
          ),
        ],
      ),
    );
  }
}
