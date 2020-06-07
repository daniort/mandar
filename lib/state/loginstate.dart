import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:mandadero/services/cliente_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginState with ChangeNotifier {
  final FirebaseStorage storage =
      FirebaseStorage(storageBucket: 'gs://mandadero-d2649.appspot.com');
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _facebookLogin = FacebookLogin();
  FirebaseUser _user;
  SharedPreferences _prefs;
  isStepPedido() => _stepPedido;
  isTipoPedido() => _tipoPedido;
  isStorage() => storage;
  FirebaseUser currentUser() => _user;
  int isLogin_Step() => _steplogin;
  int isType_User() => _type_user;
  bool islogin() => _login;
  bool isLoading() => _loading;

  LoginState() {
    loginState();
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      _user = await _auth.currentUser();
      _login = _user != null;
      _loading = false;
      notifyListeners();
    } else {
      _loading = false;
      notifyListeners();
    }
    if (_prefs.containsKey('tipe_user') == 1) {
      _type_user = 1;
      notifyListeners();
    } else {
      _type_user = 2;
      notifyListeners();
    }
  }

  bool _login = false;
  bool _loading = false;
  int _steplogin = 1;
  int _type_user = 0;
  int _stepPedido = 0;
  int _tipoPedido = 1;
  bool _cvvfocus = false;

  void logout() {
    _stepPedido = 0;
    _tipoPedido = 1;
    //_prefs.clear();
    removeValues();
    _login = false;
    _steplogin = 1;
    _type_user = 0;
    _auth.signOut();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
    notifyListeners();
  }

  socialLogin(int index) async {
    _loading = true;
    notifyListeners();

    _loading = false;

    switch (index) {
      case 2: //facebook
        await _facebookLogin.logIn(['email', 'public_profile']).then((result) {
          switch (result.status) {
            case FacebookLoginStatus.loggedIn:
              AuthCredential credential = FacebookAuthProvider.getCredential(
                  accessToken: result.accessToken.token);
              _auth.signInWithCredential(credential).then((res) {
                _user = res.user;
                print("Login Faceboon Hecho" + _user.displayName);
              }).catchError((e) {
                print(e);
              });
              if (_user != null) {
                _prefs.setBool('isLoggedIn', true);
                _login = true;
                notifyListeners();
              } else {
                _login = false;
                notifyListeners();
              }
              break;
            case FacebookLoginStatus.cancelledByUser:
              print('Login Facebook Cancelado por el Usuario.');
              break;
            case FacebookLoginStatus.error:
              print('Error Login Facebook: ${result.errorMessage}');
              break;
          }
        });
        break;
      case 3: //google
        final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        _user = (await _auth.signInWithCredential(credential)).user;
        if (_user != null) {
          _prefs.setBool('isLoggedIn', true);
          _login = true;
          notifyListeners();
        } else {
          _login = false;
          notifyListeners();
        }
        break;
      default:
    }
  }

  Future<String> loginWithEmail(String email, String pass) async {
    final curretUser = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((FirebaseUser) async {
      _user = currentUser();
      _login = true;

      notifyListeners();
      return FirebaseUser.user.uid;
    }).catchError((e) {
      print('error al auntentificar');
      return "null";
    });
  }

  Future<String> registroEmail(String email, String pass, String name) async {
    try {
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
    } catch (e) {
      return null;
    }
  }

  setTipoPedido(int n) {
    _tipoPedido = n;
    notifyListeners();
    print("tipo:" + _tipoPedido.toString());
  }

  setStepPedido(int n) {
    _stepPedido = n;
    notifyListeners();
    print("paso:" + _stepPedido.toString());
  }

  void backStep() {
    _stepPedido = _stepPedido - 1;
    print("regresaste al paso: " + _stepPedido.toString());
    notifyListeners();
  }

  void plusStep() {
    _stepPedido = _stepPedido + 1;
    print("pasaste al paso: " + _stepPedido.toString());
    notifyListeners();
  }

  setStepLogin(int n) {
    _steplogin = n;
    notifyListeners();
  }

  setUser(int n) {
    _prefs.setInt('tipe_user', n);
    _type_user = n;
  }

  bool isCVVFocus() => _cvvfocus;

  setCVVState(bool state) {
    _cvvfocus = state;
    notifyListeners();
  }

  addLoginPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('islogin', true);
  }

  removeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("islogin");
  }
}
