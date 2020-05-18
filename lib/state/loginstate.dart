import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

class LoginState with ChangeNotifier {
  bool _login = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _facebookLogin = FacebookLogin();

  FirebaseUser _user;

  bool isLogin() => _login;
  
  isData() => _user;


  void login(){
    _login = true;
    notifyListeners();
  }

  loginGoogle() async {
    return await _handleSignIn();
  }

  loginFB() async {
    return await _fbSignIn();
  }

 

  Future _fbSignIn() async {
    await _facebookLogin.logIn(['email', 'public_profile']).then((result) {
      print('metodo fb1');
      switch (result.status) {
        case FacebookLoginStatus.loggedIn:
          AuthCredential credential = FacebookAuthProvider.getCredential(
              accessToken: result.accessToken.token);
          _auth.signInWithCredential(credential).then((res) {
            print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>');
            print(res.user.uid);
            _user = res.user;
            notifyListeners();
          }).catchError((e) {
            print(e);
          });
          //return result.accessToken.token;
          break;
        case FacebookLoginStatus.cancelledByUser:
          print('Login Cancelado por el Usuario.');

          break;
        case FacebookLoginStatus.error:
          print('Algo paso con el logeo de facebook.\n'
              'Aqui esta el error: ${result.errorMessage}');

          break;
      }
    });
  }

  Future<String> loginEmail(String email, String pass) async {
    final curretUser = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((FirebaseUser) async {
      _user = FirebaseUser.user;
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

    _user = (await _auth.signInWithCredential(credential)).user;
    if(_user.displayName != null) {
      print('hola no funciono');
      login();
    }    
    print("signed in " + _user.displayName);
    return _user;
  }

  void logout() {
    _auth.signOut();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
    _login = false;
    notifyListeners();
  }

  
}
