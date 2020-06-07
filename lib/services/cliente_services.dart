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


}
