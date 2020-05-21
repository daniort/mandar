import 'package:flutter/material.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class Pedidos extends StatefulWidget {
  @override
  _PedidosState createState() => _PedidosState();
}

class _PedidosState extends State<Pedidos> {
 @override
 void initState()  {
   print('hola muno');

 }
 @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Color.fromRGBO(20, 20, 20, 0.5),
                  ),
                  onPressed: () {
                    Provider.of<LoginState>(context, listen: false).logout();
                  },
                ),
                Text(
                  'Salir',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromRGBO(20, 20, 20, 0.5),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: alto * .25,
                      height: alto * .25,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(20, 20, 20, 0.2), width: 5.0),
                        boxShadow: [
                          BoxShadow(color: Colors.white10, blurRadius: 25)
                        ],
                        image: new DecorationImage(
                            image: new NetworkImage(
                              "${_user.photoUrl}",
                            ),
                            fit: BoxFit.fill),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Text(
                    "Cliente",
                    style: TextStyle(
                        fontSize: 15,
                        color: Color(0xff484349),
                        fontWeight: FontWeight.normal,
                  ),),
                  Text(
                    "${_user.displayName}",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color(0xff484349),
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${_user.email}",
                    style: TextStyle(
                      fontSize: 11,
                      color: Color(0xff484349),
                    ),
                  ),
                  
                      
                    
                ],
              ),
            ),
          ),
          Container(
            height: alto * 0.35,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xff484349),
                  blurRadius: 20.0, // has the effect of softening the shadow
                  spreadRadius: 3.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    10.0, // vertical, move down 10
                  ),
                )
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xfff6f9ff),
                          ),
                          width: ancho * 0.5,
                          height: alto * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.pin_drop,
                                size: 17,
                                color: Color.fromRGBO(20, 20, 20, 0.5),
                              ),
                              SizedBox(
                                width: 2.0,
                              ),
                              Text(
                                'Calle Guerrero No. 15',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(20, 20, 20, 0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Color(0xfff6f9ff),
                          ),
                          width: ancho * 0.5,
                          height: alto * 0.06,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Editar Datos',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Icon(
                                Icons.edit,
                                size: 15,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: ancho * 0.35,
                        height: alto * 0.27,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [Color(0xfff6f9ff), Color(0xfff6f9ff)],
                              begin: Alignment.topLeft),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                'Número de\nPedidos:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff484349),
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: Color(0xff484349),
                                    fontSize: 35,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '¡Comienza Ahora!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xff484349),
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
