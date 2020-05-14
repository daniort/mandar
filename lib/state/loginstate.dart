import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginState with ChangeNotifier {
  bool _login = false;
  int _tipe = 0;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool isLogin() => _login;
  int isTipe() => _tipe;

  void login() async {
    print('login metodo');
    print(_tipe);
    _login = true;
    notifyListeners();
  }

  loginGoogle() async {
    return await _handleSignIn();
  }

  void type(int n) async {
    if (n == 1) {
      _tipe = 1;
      notifyListeners();
    } else {
      _tipe = 2;
      notifyListeners();
    }
  }

  Future<String> loginEmail(String email, String pass) async {
    final curretUser = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((FirebaseUser) async {
      return FirebaseUser.user.uid;
    }).catchError((e) {
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

  Future<FirebaseUser> _handleSignIn() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    print("signed in " + user.displayName);
    return user;
  }

  void logout() {
    _login = false;
    notifyListeners();
  }
}
