import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mandadero/state/loginstate.dart';

class UserServices {
  void newUser(FirebaseUser user) async {
    var _mail = "null";
    try {
      print('vamos a intentar el try');
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('datos')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot doc) {
        _mail = doc["email"];
      });
    } catch (e) {
      print(e);
      print('error en checar si ya esta el usuario');
    }
    if (_mail == "null") {
      Firestore.instance
          .collection('users')
          .document(user.uid)
          .collection('datos')
          .document(user.uid)
          .setData({
        "email": user.email,
        "nombre": user.displayName,
        "telefono": user.phoneNumber,
      });
    }
  }

  void newPedidoPagoServicios(String titulo, String cantidad, String ubicacion,
      String datos, FirebaseUser user) {
    int dia = DateTime.now().day;
    int mes = DateTime.now().month;
    int ano = DateTime.now().year;
    String horai =
        DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('pedidos')
        .document()
        .setData({
      "tipo": 'pago',
      "titulo": titulo,
      "cantidad": cantidad,
      "ubicacion": ubicacion,
      "datos": datos,
      "cliente": user.uid,
      "status": "espera",
      "dia": dia,
      "mes": mes,
      "year": ano,
      "horai": horai,
      "urlrecibocliente": "null",
      "fin_repartidor": false,
      "fin_cleinte": false,
    });
  }
}
