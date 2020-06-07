import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

class FinalizarPedido extends StatefulWidget {
  String data;
  FinalizarPedido({Key key, @required this.data}) : super(key: key);
  @override
  _FinalizarPedidoState createState() => _FinalizarPedidoState(data);
}

class _FinalizarPedidoState extends State<FinalizarPedido> {
  String data;
  String filePath = "recibos_repartidor/${DateTime.now()}.png";
  StorageUploadTask _uploadTask;
  final ImagePicker picker = ImagePicker();
  File _image;
  final FirebaseStorage _sto = LoginState().isStorage();

  _FinalizarPedidoState(String data);
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<LoginState>(context, listen: false).currentUser();
    final alto = MediaQuery.of(context).size.height;
    final ancho = MediaQuery.of(context).size.width;
    final _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xff464d77),
      appBar: AppBar(
          backgroundColor: Color(0xfff6f9ff),
          iconTheme: IconThemeData(color: Colors.grey),
          elevation: 0.3,
          title: Text(
            'Finalizar Pedido',
            style: TextStyle(
              fontSize: 18,
              color: Color.fromRGBO(20, 20, 20, 0.5),
            ),
          )),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              width: ancho,
              decoration: BoxDecoration(
                color: Color(0xfff6f9ff),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Text("Gracias por realizar el pedido",
                        style: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        "Si cuentas con un comprobante, por favor,\n mandanos una foto",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: ancho * .5,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromRGBO(20, 20, 20, 0.2), width: 5.0),
                      ),
                      child: _image == null
                          ? Center(
                              child: Image.asset(
                              'lib/assets/error.png',
                            ))
                          : Stack(
                              children: <Widget>[
                                Center(
                                  child: Image.file(
                                    _image,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: IconButton(
                                      color: Color(0xffee6179),
                                      icon: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _image = null;
                                        });
                                      }),
                                ),
                                
                              ],
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      _image == null
                          ? 'Si no lo tienes, puedes continuar'
                          : 'Genial, lo Tenemos, Continúa...',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      print('tomar foto');
                      try {
                        _pickImage();
                      } catch (e) {
                        print("Error wee $e");
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: InkWell(
              onTap: () async {
                final _user = Provider.of<LoginState>(context, listen: false)
                    .currentUser();
                var _urlim = await _subirImagen(_image);

                var _pedidoFinalizado = UserServices()
                    .finalizaRepartidor(widget.data, _user, _urlim);

                if (_pedidoFinalizado) {
                  Navigator.of(context).pop();
                 
                } else {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Algo Pasó, Intentalo de Nuevo'),
                    backgroundColor: Color(0xffee6179),
                    duration: Duration(milliseconds: 3000),
                  ));
                  
                }
              },
              child: Container(
                width: ancho,
                height: alto * 0.065,
                child: Center(
                  child: Text(
                    'Finalizar Pedido',
                    style: GoogleFonts.courgette(
                      fontSize: 20,
                      color: Color(0xfff6f9ff),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _pickImage() async {
    try {
      final select = await picker.getImage(source: ImageSource.camera);
      setState(() {
        _image = File(select.path);
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<String> _subirImagen(File image) async {
    print('vamos a intrar al try');
    try {
      print('dentro del try');
      setState(() {
        _uploadTask = _sto.ref().child(filePath).putFile(_image);
      });
      var dowurl = await (await _uploadTask.onComplete).ref.getDownloadURL();
      var url = dowurl.toString();
      print('acabando de subir la imagen');
      return url;
    } catch (e) {
      return 'null';
    }
  }
}
