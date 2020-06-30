import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class NuevaUbicacion extends StatefulWidget {
  final String data;
  NuevaUbicacion({Key key, @required this.data}) : super(key: key);

  @override
  _NuevaUbicacionState createState() => _NuevaUbicacionState();
}

class _NuevaUbicacionState extends State<NuevaUbicacion> {
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

  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xfff6f9ff),
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Color(0xfff6f9ff),
        title: Text(
          'Selecciona la Ubicación',
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
                        onTap: (val) {
                          _getAddressFromLatLng(val.latitude, val.longitude);
                          setState(() {
                            miMarker = val;
                          });
                          _updateMarker(val);
                        },
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
              _markers.length != 0
                  ? Container(
                      height: 50,
                      width: ancho,
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
                      child: Flexible(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                                "${place.thoroughfare}, #${place.subThoroughfare}, ${place.subLocality}, ${place.locality}",
                                style: TextStyle(color: Colors.grey),
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
              _markers.length != 0
                  ? InkWell(
                      splashColor: Colors.grey[900],
                      onTap: () {
                        Provider.of<LoginState>(context, listen: false)
                            .setUbicacion(
                                "${place.thoroughfare}, #${place.subThoroughfare}, ${place.subLocality}, ${place.locality}",
                                _currentPosition.latitude,
                                _currentPosition.longitude,
                                widget.data);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        width: ancho,
                        height: 40.0,
                        color: Colors.grey[800],
                        child: Center(
                          child: Text(
                            'Confirmar Ubicación',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
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

  Future<void> _actualizarMarcador() async {
    double lat = 40.7128;
    double long = -74.0060;
    GoogleMapController controller = await mapController;
    controller.animateCamera(CameraUpdate.newLatLngZoom(LatLng(lat, long), 10));
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
