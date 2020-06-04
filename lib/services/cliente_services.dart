import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';

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
        print('si esta el usuario');
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
          //.collection('users')
          //.document(user.uid)
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

  void primero(
      FirebaseUser user,
      String nombre,
      String correo,
      String telefono,
      String direccion,
      String tarjeta,
      String nota,
      String mes,
      String year,
      bool ocupado) {
    Firestore.instance.collection('users').document(user.uid).setData({
      'nombre': nombre,
      'email': correo,
      'telefono': telefono,
      'direccion': direccion,
      'tarjeta': tarjeta,
      'nota': nota,
      'mes': mes,
      'año': year,
      'ocupado': false,
    }, merge: true);
  }

  void name(FirebaseUser user, String nombre) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'nombre': nombre,
    });
  }

  void email(FirebaseUser user, String correo) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'email': correo,
    });
  }

  void tele(FirebaseUser user, String telefono) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'telefono': telefono,
    });
  }

  void direc(FirebaseUser user, String direccion) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'direccion': direccion,
    });
  }

  void card(FirebaseUser user, String tarjeta) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'tarjeta': tarjeta,
    });
  }

  void note(FirebaseUser user, String nota) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'nota': nota,
    });
  }

  void month(FirebaseUser user, String mes) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'mes': mes,
    });
  }

  void ano(FirebaseUser user, String year) {
    Firestore.instance.collection('users').document(user.uid).updateData({
      'año': year,
    });
  }
}
