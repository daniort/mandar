import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  void newUser(FirebaseUser user, int type_user) async {
    var _existe = false;
    try {
      Firestore.instance
          .collection(type_user == 1 ? 'users' : 'repartidores')
          .document(user.uid)
          .collection('datos')
          .document(user.uid)
          .get()
          .then((DocumentSnapshot doc) {
        _existe = true;
      });
    } catch (e) {
      print(e);
      print('error en checar si ya esta el usuario');
    }
  }

  bool newPedidoPagoServicios(String titulo, String cantidad, String ubicacion,
      String datos, FirebaseUser user) {
    int dia = DateTime.now().day;
    int mes = DateTime.now().month;
    int ano = DateTime.now().year;
    String horai =
        DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();
    try {
      Firestore.instance
          .collection('pedidos')
          .document()
          .setData({
        "id_pedido": "",
        "tipo": 'pago',
        "titulo": titulo,
        "cantidad": cantidad,
        "ubicacion": ubicacion,
        "datos": datos,
        "cliente": user.uid,
        "repartidor": "",
        "status": "espera",
        "dia": dia,
        "mes": mes,
        "year": ano,
        "horai": horai,
        "horaf": "",
        "urlrecibocliente": "null",
        "urlreciborepartidor": "null",
        "fin_repartidor": false,
        "fin_cliente": false,
      }).then((value) {
        print('hola');
      });
      return true;
    } catch (e) {
      print("error al guardar el pedido");
      return false;
    }
  }

  static bool finalizaRepartidor(String documentID, FirebaseUser user) {
    try {
      Firestore.instance
          .collection('pedidos')
          .document(documentID)
          .updateData({'fin_repartidor': true, "status" : "finalizado"}).then((value) {
        Firestore.instance
            .collection('repartidores')
            .document(user.uid)
            .collection('datos')
            .document(user.uid)
            .updateData({'ocupado': false});
      });
      return true;
    } catch (e) {
      print("error al guardar el pedido");
      return false;
    }
  }
}
