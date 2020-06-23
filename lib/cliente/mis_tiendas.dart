import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';


class MisTiendas extends StatefulWidget {
  @override
  _MisTiendasState createState() => _MisTiendasState();
}

class _MisTiendasState extends State<MisTiendas> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xfff6f9ff),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Color(0xfff6f9ff),
        title: Text(
          'Mis Tiendas',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xffee6179),
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BuscarMapa(),
              ),
            );
          }),
      body: Container(
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance
              .collection('users')
              .document(_user.uid)
              .collection('tiendas')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) return new Text('Error: ${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Center(
                        child: CircularProgressIndicator(
                      backgroundColor: Colors.grey,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(Color(0xffee6179)),
                    )),
                    new Text('Cargando...',
                        style: TextStyle(color: Colors.grey)),
                  ],
                );
              default:
                if (snapshot.data.documents.length == 0) {
                  return Center(
                    child: Text(
                        'No tienes ninguna tienda,\n¡Agrega una ahora!\n',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 23,
                            fontWeight: FontWeight.bold)),
                  );
                } else {
                  return new ListView(
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 5,
                              child: RichText(
                                text: TextSpan(
                                  text: document['nombre'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black54),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: '\n',
                                    ),
                                    TextSpan(
                                      text:
                                          "${document['calle']}, #${document['numero']}, ${document['localidad']}, ${document['ciudad']}",
                                      style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 8),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Color.fromRGBO(238, 97, 121, 0.7),
                                  onPressed: () {
                                    return showDialog<void>(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Eliminar Tienda'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text(
                                                    '¿Estas seguro de eliminar este lugar?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              child: Text(
                                                'Cancelar',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Eliminar'),
                                              color: Color(0xffee6179),
                                              onPressed: () async {
                                                bool _eliminar =
                                                    await UserServices()
                                                        .eliminarPedido(
                                                            document.documentID,
                                                            _user.uid);
                                                if (_eliminar) {
                                                  Navigator.of(context).pop();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Dirección Eliminada '),
                                                    duration: Duration(
                                                        milliseconds: 1500),
                                                    backgroundColor:
                                                        Color(0xffee6179),
                                                  ));
                                                } else {
                                                  Navigator.of(context).pop();
                                                  _scaffoldKey.currentState
                                                      .showSnackBar(SnackBar(
                                                    content: Text(
                                                        'Algo salió mal, Intenta nuevamente'),
                                                    duration: Duration(
                                                        milliseconds: 2500),
                                                    backgroundColor:
                                                        Color(0xffee6179),
                                                  ));
                                                }
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

class BuscarMapa extends StatefulWidget {
  @override
  _BuscarMapaState createState() => _BuscarMapaState();
}

class _BuscarMapaState extends State<BuscarMapa> {
  GoogleMapController mapController;
  TextEditingController _tituloController;

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  bool _buscadoUbicacion = true;
  Position _currentPosition;
  String ubicacion = ' ';
  String numero = '0';
  LatLng miMarker;

  final Set<Marker> _markers = {};
  Placemark place;

  void initState() {
    _tituloController = TextEditingController();
    _getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff6f9ff),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Color(0xfff6f9ff),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Buscar una Dirección",
            border: InputBorder.none,
          ),
          onSubmitted: (val) {
            setState(() {
              ubicacion = val;
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              if (ubicacion.length >= 6) {
                try {
                  buscarDireccion();
                } catch (e) {
                  print(e);
                }
              } else {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Ingresa algo más'),
                  duration: Duration(milliseconds: 2500),
                  backgroundColor: Color(0xffee6179),
                ));
              }
            },
            icon: Icon(Icons.search),
          ),
        ],
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
                        onTap: (val) {
                          _getAddressFromLatLng(val.latitude, val.longitude);
                          setState(() {
                            miMarker = val;
                          });
                          _updateMarker(val);
                        },
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
              _markers.length != 0
                  ? Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff484349),
                            blurRadius:
                                20.0, // has the effect of softening the shadow
                            spreadRadius:
                                3.0, // has the effect of extending the shadow
                            offset: Offset(
                              0.0, // horizontal, move right 10
                              10.0, // vertical, move down 10
                            ),
                          )
                        ],
                        color: Color(0xfff6f9ff),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.pin_drop,
                                  color: Colors.grey,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Flexible(
                                  child: Text(
                                      "${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}",
                                      style: TextStyle(color: Colors.grey)),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 45.0, left: 10, right: 10),
                            child: TextField(
                              controller: _tituloController,
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Nombra esta Dirección',
                                  helperText: 'Ejemplo: Mercado Revolución',
                                  prefixIcon: Icon(Icons.store)),
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
          _tituloController.text.isNotEmpty
              ? Align(
                  alignment: Alignment.bottomCenter,
                  child: InkWell(
                    onTap: () {
                      return showDialog<void>(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Guardar Dirección'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text(
                                        '${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}',
                                        style: TextStyle(color: Colors.grey)),
                                    Text('como:',
                                        style: TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.store,
                                            color: Colors.blueGrey,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _tituloController.text
                                                .toUpperCase(),
                                            style: TextStyle(
                                              color: Colors.blueGrey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text(
                                    'Cancelar',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Guardar'),
                                  color: Color(0xffee6179),
                                  onPressed: () async {
                                    bool _guardado =
                                        UserServices().guardarNuevaUbicacion(
                                      _tituloController.text,
                                      place.thoroughfare,
                                      place.subThoroughfare,
                                      place.subLocality,
                                      place.locality,
                                      _user.uid,
                                      miMarker.latitude,
                                      miMarker.longitude,
                                    );

                                    if (_guardado) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    } else {
                                      Navigator.of(context).pop();
                                      _scaffoldKey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Algo salió mal, Intenta nuevamente'),
                                        duration: Duration(milliseconds: 2500),
                                        backgroundColor: Color(0xffee6179),
                                      ));
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                    },
                    child: Container(
                      width: ancho,
                      height: 40.0,
                      color: Color(0xffee6179),
                      child: Center(
                        child: Text(
                          'Guardar',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      print('obteniendo ubicacion');
      setState(() {
        _currentPosition = position;
        _buscadoUbicacion = false;
      });
      _getAddressFromLatLng(
          _currentPosition.latitude, _currentPosition.longitude);
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng(double latitude, double longitude) async {
    try {
      List<Placemark> p =
          await geolocator.placemarkFromCoordinates(latitude, longitude);

      setState(() {
        place = p[0];
        numero = place.subThoroughfare;
      });
    } catch (e) {
      print(e);
    }
  }

  buscarDireccion() {
    if (ubicacion.length >= 6) {
      try {
        Geolocator().placemarkFromAddress(ubicacion).then((value) {
          print("error we >777777777777777777777777>>>>>>>>>>>>>>>");
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                  target: LatLng(
                      value[0].position.latitude, value[0].position.longitude),
                  zoom: 10.0),
            ),
          );
        }).catchError((onError) {
          print("error we >>>>>>>>>>>>>>>>");
          print(onError);
        });
      } catch (e) {
        print("error we >>>>>>>>>>>>>>>>");
        print(e);
      }
    }
  }



  void onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  void _updateMarker(LatLng val) {
    LatLng _ubi = new LatLng(val.latitude, val.longitude);
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId("tienda"),
          position: _ubi,
          infoWindow: InfoWindow(
            title: 'Aquí',
            snippet:
                '${place.thoroughfare}, ${place.subThoroughfare}, ${place.subLocality}, ${place.locality}',
          ),
        ),
      );
    });
  }
}
