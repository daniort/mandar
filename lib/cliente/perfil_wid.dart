import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class DataCliente extends StatefulWidget {
  @override
  _DataClienteState createState() => _DataClienteState();
}

class _DataClienteState extends State<DataCliente> {
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app,
                    color: Color.fromRGBO(240, 240, 240, 0.9),
                  ),
                  onPressed: () {
                    Provider.of<LoginState>(context, listen: false).logout();
                  },
                )
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        width: alto * .3,
                        height: alto * .3,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(color: Colors.white10, blurRadius: 25)
                          ],
                          image: new DecorationImage(
                              image: new NetworkImage(
                                "${_user.photoUrl}",
                              ),
                              fit: BoxFit.fill),
                          borderRadius: BorderRadius.circular(150),
                        )),
                  ),
                  Text(
                    "${_user.displayName}",
                    //textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Editar Perfil',
                            style: TextStyle(
                                fontSize: 11,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Icon(
                            Icons.edit,
                            size: 11,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
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
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
