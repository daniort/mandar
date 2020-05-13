import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  bool _login = false;
  //final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLogin() => _login;

  void login() async {
    print('login metodo');
    _login = true;
    notifyListeners();
  }

Future<String> loginEmail(String email, String pass) async {
   final curretUser = await _auth.signInWithEmailAndPassword(email: email, password: pass)
   .then((FirebaseUser) async {
     return FirebaseUser.user.uid;
   }).catchError((e){
     print('error al auntentificar');
     return "null";
   });


}
  Future<String> signupEmail(String email, String pass, String name) async {
     final curretUser = await _auth.createUserWithEmailAndPassword(
      email: '$email',
      password: '$pass',
    );
    //add name
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await curretUser.user.updateProfile(userUpdateInfo);
    await curretUser.user.reload();
    return curretUser.user.uid;
  }

  void logout() {
    _login = false;
    notifyListeners();
  }
}
