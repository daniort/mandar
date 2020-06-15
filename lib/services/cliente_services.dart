import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mandadero/state/loginstate.dart';

class UserServices {
  bool newPedidoPagoServicios(String titulo, String cantidad, String ubicacion,
      String datos, FirebaseUser user, String image) {
    int dia = DateTime.now().day;
    int mes = DateTime.now().month;
    int ano = DateTime.now().year;
    String horai =
        DateTime.now().hour.toString() + ':' + DateTime.now().minute.toString();

    try {
      Firestore.instance.collection('pedidos').document().setData({
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
