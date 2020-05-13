import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

import 'Router/generateRouter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(

      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        onGenerateRoute: Router().generateRoute,
        initialRoute: mainRoute,
        title: "Mandaderos",
        routes: {
          mainRoute: (BuildContext context) {
            var state = Provider.of<LoginState>(context);
            if (state.isLogin()) {
              return HomeScreen();
            } else {
              return FirtsPage();
            }
          }
          //5'/add': (BuildContext context) => AddPage();
        },
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}

class FirtsPage extends StatefulWidget {
  @override
  _FirtsPageState createState() => _FirtsPageState();
}

class _FirtsPageState extends State<FirtsPage> {
  @override
  Widget build(BuildContext context) {
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      
      backgroundColor: Color(0xfff6f4f3),
      body: Center(
          child: Column(
        children: <Widget>[
          Container(
            height: alto * 0.7,
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(100.0)),
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
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(100.0)),
                        color: Color(0xffdde9f7),
                        //borderRadius: BorderRadius.circular(80.0)),
                      )),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                          width: ancho * 0.6,
                          child: Center(
                            child: Image.asset(
                              'lib/assets/logo.png',
                            ),
                          ),
                          decoration: BoxDecoration(
                            //color: Color.fromRGBO(24, 24, 24,0.5),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100.0)),
                          )),
                      Container(
                          width: ancho * 0.7,
                          height: 60,
                          child: Center(
                            child: Text(
                              'Mandaderos',
                              style: GoogleFonts.courgette(
                                fontSize: 40,
                                color: Color(0xff292f36),
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(100.0)),

                            //borderRadius: BorderRadius.circular(80.0)),
                          )),
                      Container(
                        width: ancho * 0.7,
                        child: Center(
                          child: Text(
                            'No algas de casa\nNosotros te hacemos los mandados',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100.0)),

                          //borderRadius: BorderRadius.circular(80.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: alto * 0.03,
            color: Color(0xffdde9f7),
          ),
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8.0, right: 8.0, bottom: 8.0, top: 16.0),
                  child: InkWell(
                    child: Container(
                      width: ancho * 0.6,
                      height: alto * 0.06,
                      decoration: BoxDecoration(
                          color: Color(0xffee6179),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                        child: Text(
                          'Entrar como Repartidor',
                          style: TextStyle(
                              fontSize: 15,
                              color: Color(0xfff6f4f3),
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, loginClienteRoute);
                    },
                    child: Container(
                      width: ancho * 0.6,
                      height: alto * 0.06,
                      decoration: BoxDecoration(
                          color: Color(0xffee6179),
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                          child: Text(
                        'Entrar como Cliente',
                        style: TextStyle(
                            fontSize: 15,
                            color: Color(0xfff6f4f3),
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: InkWell(
                    child: Container(
                      width: ancho * 0.6,
                      height: alto * 0.06,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0)),
                      child: Center(
                          child: Text(
                        'Podrás volver a salir y entrar de manera diferente cuando lo desees',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 9,
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      )),
    );
  }
}
