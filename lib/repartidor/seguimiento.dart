import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandadero/services/widgets.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class Seguir extends StatefulWidget {
  @override
  _SeguirState createState() => _SeguirState();
}

class _SeguirState extends State<Seguir> {
  GoogleMapController mapController;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool _buscadoUbicacion = true;
  Position _currentPosition;
  String ubicacion = ' ';
  String numero = '0';
  LatLng miMarker;
  final Set<Marker> _markers = {};
  Placemark place;
  List destino;
  DocumentSnapshot data;
  int posmenor;

  void initState() {
    data = Provider.of<LoginState>(context, listen: false).documentoActivo;
    _getCurrentLocation();
//    _getPunto();
    super.initState();
  }

  Widget build(BuildContext context) {
    final _state = Provider.of<LoginState>(context, listen: true);
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff6f9ff),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Color(0xfff6f9ff),
        title: Text(
          'En Camino...',
          style: TextStyle(color: Colors.grey[400]),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 1,
                child: _buscadoUbicacion
                    ? Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color.fromRGBO(238, 97, 121, 0.7),
                          ),
                        ),
                      )
                    : GoogleMap(
                        buildingsEnabled: false,
                        markers: _markers,
                        onMapCreated: onMapCreated,
                        myLocationEnabled: true,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_currentPosition.latitude,
                              _currentPosition.longitude),
                          zoom: 18.0,
                        ),
                      ),
              ),
              Container(
                //height: 50,
                width: ancho,
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xff484349),
                      blurRadius: 20.0,
                      spreadRadius: 3.0,
                      offset: Offset(0.0, 10.0),
                    )
                  ],
                  color: Color(0xfff6f9ff),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                    topRight: Radius.circular(20.0),
                  ),
                ),
                child: Flexible(
                  child: Column(
                    children: <Widget>[
                      //                     posmenor != null ?
                      //textoLista(data['lista'][posmenor]['nombre'].toString().toUpperCase()):SizedBox(),
//                      textoListaDirec("s"):SizedBox(),
                      Text("Compra:",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold)),
                      for (var item in data['lista'])
                        data['lista'][posmenor]['punto']['label'] ==
                                item['punto']['label']
                            ? textoListaDirec(
                                "\$${item['cantidad'].toString().toUpperCase()} de ${item['nombre'].toString().toUpperCase()}")
                            : SizedBox(),
                      //textoListaDirec(data['lista'][posmenor]['label']),
                      //if (item['punto']['label'] == data['lista'][posmenor]['label']) textoListaDirec(item['punto']['nombre']),

                      //: textoListaDirec("..."),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.grey[900],
                      onTap: () {
                        _getPunto();
                      },
                      child: Container(
                        height: 40.0,
                        color: Colors.grey[800],
                        child: Center(
                          child: Text(
                            'Estoy Aquí',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      splashColor: Colors.grey[900],
                      onTap: () {
                        //eliminar del arreglo la posicion menro actual
                        print(data['lista']);
                        print("ZZZZZ>>>>>>>>>>>>>>>>>>>");
                        data.data['lista'].remove(posmenor);//  removeAt(posmenor);
                        print(data['lista']);
                        _getPunto();
                      },
                      child: Container(
                        height: 40.0,
                        color: Colors.grey[800],
                        child: Center(
                          child: Text(
                            'Siguiente Parada',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
          Container(
            padding: EdgeInsets.only(left: 10, top: 5),
            height: alto * 0.15,
            width: ancho * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("Dirigete a:",
                    style: TextStyle(fontSize: 18, color: Colors.grey[500])),
                Expanded(
                    child: Text(
                        !_buscadoUbicacion
                            ? data.data["lista"][posmenor]['punto']['label']
                            : "",
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _getCurrentLocation() {
    try {
      geolocator
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
          .then((Position position) {
        print("getCurrectLocation dice: Hola");
        setState(() {
          _currentPosition = position;
        });
        _getAddressFromLatLng(
            _currentPosition.latitude, _currentPosition.longitude);
      }).catchError((e) {
        print("getCurrectLocation dice:" + e);
      });
    } catch (e) {
      print("getCurrectLocation dice error::" + e);
    }
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> p = await geolocator
          .placemarkFromCoordinates(latitude, longitude)
          .catchError((e) {
        print("error aqui we");
      });

      setState(() {
        place = p[0];
        numero = place.subThoroughfare;
      });
      _getPunto();
    } catch (e) {
      print(e);
    }
  }

  void _getPunto() {
    print(">>>>>>>>>>>>>GET PUNTO>>>>>>>>>>>><");
    print(_currentPosition);
    if (_currentPosition != null) {
      _llenarDistancias();
      posmenor = _obtenerPosicion();
      _createMarkers(); //data.data["lista"][posmenor]
      //pasar marcadores al mapa
      //trazar ruta
      //acutlizar ubicacion del reprtidor
    } else {
      print("getPunto dice: Hola");
    }
  }

  Set<Marker> _createMarkers() {
    _markers.clear();
    _markers.add(
      Marker(
        markerId: MarkerId("yo"),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      ),
    );
    _markers.add(
      Marker(
        markerId: MarkerId("destino"),
        position: LatLng(data.data["lista"][posmenor]['punto']['latitud'],
            data.data["lista"][posmenor]['punto']['longitud']),
      ),
    );
    _buscadoUbicacion = false;
  }

  
  int _obtenerPosicion() {
    int _pos = 0;
    for (var i = 0; i < data.data["lista"].length; i++) {
      if (i == 0) {
        _pos = i;
      } else {
        if (data.data["lista"][i]['distancia'] <
            data.data["lista"][_pos]['distancia']) {
          _pos = i;
        }
      }
    }
    return _pos;
  }

  void _llenarDistancias() async {
    for (var item in data.data["lista"]) {
      item['distancia'] = await Geolocator().distanceBetween(
        _currentPosition.latitude,
        _currentPosition.longitude,
        item['punto']['latitud'],
        item['punto']['longitud'],
      );
    }
  }

  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  Widget textoLista(String s) {
    return Text("$s:",
        textAlign: TextAlign.right,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold));
  }

  Widget textoListaDirec(String s) {
    print("________________________--------------------_________________");
    print(data['lista'][posmenor]['punto']['label']);
    //print(data['lista'][0]['punto']['label']);
    //print(data['ĺista'][1]['punto']['label']);
    print(s);
    return Text(s, textAlign: TextAlign.left, style: TextStyle(fontSize: 12));
  }
}
