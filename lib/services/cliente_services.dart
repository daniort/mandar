import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
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

  void newUser(FirebaseUser user, int type_user) async {
    var _existe = false;
    try {
      print('vamos a intentar el try');
      Firestore.instance
          .collection(type_user == 1 ? 'users' : 'repartidores')
          .document(user.uid)
          .collection('datos')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot doc) {
        _existe = true;
        print('si esta el usuario');
      });
    } catch (e) {
      print(e);
      print('error en checar si ya esta el usuario');
    }
    if (!_existe) {
      Firestore.instance
          .collection(type_user == 1 ? 'users' : 'repartidores')
          .document(user.uid)
          .collection('datos')
          .document(user.uid)
          .setData({
        "email": user.email,
        "nombre": user.displayName,
        "telefono": user.phoneNumber,
        "direccion": "null",
        "nota": "null",
        "tarjeta": "null",
        "mes": "null",
        "ano": "null",
        "cliente": "null",
      });
    }
  }
}

class Update {
  void updateuser(FirebaseUser user, nuevo) {
    Firestore.instance
        .collection('users')
        .document(user.uid)
        .collection('datos')
        .document(user.uid)
        .updateData(nuevo)
        .catchError((e) {
      print(e);
    });
  }
}
