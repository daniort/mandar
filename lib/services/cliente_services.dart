import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  bool newPedidoProductos(List orderLines, int subtotal, int totalPedido,
      FirebaseUser user, puntoa, puntob) {
    var hoy = DateTime.now();
    try {
      Firestore.instance.collection('pedidos').document().setData({
        "id_pedido": "",
        "tipo": 'producto',
        "lista": orderLines,
        "subtotal": subtotal,
        "total": totalPedido,
        "cliente": user.uid,
        "repartidor": "",
        "status": "espera",
        "dia": hoy.day,
        "mes": hoy.month,
        "year": hoy.year,
        "horai": "${hoy.hour}:${hoy.minute}:${hoy.second}",
        "horaf": "",
        "puntoa": puntoa,
        "puntob": puntob,
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

  bool newPedidoPagoServicios(String titulo, String datos, int subtotal,
      int totalPedido, FirebaseUser user, String image, puntoa) {
    var hoy = DateTime.now();
    try {
      Firestore.instance.collection('pedidos').document().setData({
        "id_pedido": "",
        "tipo": 'pago',
        "titulo": titulo,
        "subtotal": subtotal,
        "total": totalPedido,
        "datos": datos,
        "cliente": user.uid,
        "repartidor": "",
        "status": "espera",
        "dia": hoy.day,
        "mes": hoy.month,
        "year": hoy.year,
        "horai": "${hoy.hour}:${hoy.minute}:${hoy.second}",
        "horaf": "",
        "puntoa": puntoa,
        "urlrecibocliente": image,
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

  bool finalizaRepartidor(String documentID, FirebaseUser user, String urlim) {
    try {
      Firestore.instance.collection('pedidos').document(documentID).updateData(
          {'fin_repartidor': true, "status": "finalizado"}).then((value) {
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

  bool guardarNuevaUbicacion(
      String label,
      String calle,
      String numero,
      String localidad,
      String ciudad,
      String uid,
      double latitude,
      double longitude) {
    try {
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tiendas')
          .document()
          .setData({
        "nombre": label.toUpperCase(),
        "calle": calle,
        "numero": numero,
        "localidad": localidad,
        "ciudad": ciudad,
        "latitud": latitude,
        "longitud": longitude,
      }).then((value) {
        print('hola');
      });
      return true;
    } catch (e) {
      print("error al guardar el pedido");
      return false;
    }
  }

  Future<bool> eliminarPedido(String documentID, String uid) async {
    try {
      Firestore.instance
          .collection('users')
          .document(uid)
          .collection('tiendas')
          .document(documentID)
          .delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> actualizarNumero(
      String text, String documentID, String userID) async {
    try {
      Firestore.instance
          .collection('users')
          .document(userID)
          .collection('tiendas')
          .document(documentID)
          .updateData({'numero': text});
      return true;
    } catch (e) {
      return false;
    }
  }
}
