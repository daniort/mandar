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
}
