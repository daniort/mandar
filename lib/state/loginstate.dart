import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
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
  bool isError() => _error;

  LoginState() {
    loginState();
  }

  void loginState() async {
    _prefs = await SharedPreferences.getInstance();
    if (_prefs.containsKey('isLoggedIn')) {
      switch (_prefs.getInt("tipe_user")) {
        case 1:
          _type_user = 1;
          _user = await _auth.currentUser();
          _login = _user != null;
          _loading = false;
          notifyListeners();
          break;
        case 2:
          _type_user = 2;
          _user = await _auth.currentUser();
          _login = _user != null;
          _loading = false;
          notifyListeners();
          break;
      }
    } else {
      _loading = false;
      notifyListeners();
    }
  }

  bool _login = false;
  bool _error = false;
  bool _loading = false;
  int _steplogin = 1;
  int _type_user = 0;
  int _stepPedido = 0;
  int _tipoPedido = 1;
  bool _cvvfocus = false;

  void logout() {
    _error = false;
    _stepPedido = 0;
    _tipoPedido = 1;
    _prefs.clear();
    _prefs.remove('tipe_user'); // removeValues();
    _login = false;
    _steplogin = 1;
    _type_user = 0;
    _auth.signOut();
    _googleSignIn.signOut();
    _facebookLogin.logOut();
    notifyListeners();
  }

  void _salioError() async {
    _error = true;
    notifyListeners();
    await new Future.delayed(const Duration(seconds: 10));
    _error = false;
    notifyListeners();
  }

  socialLogin(int index) async {
    _error = false;
    _loading = true;
    notifyListeners();
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
                if (_user != null) {
                  _prefs.setBool('isLoggedIn', true);
                  _login = true;
                  _loading = false;
                  notifyListeners();
                } else {
                  _login = false;
                  _salioError();
                  notifyListeners();
                }
              }).catchError((e) {
                print(e);
              });

              break;
            case FacebookLoginStatus.cancelledByUser:
              print('Login Facebook Cancelado por el Usuario.');
              _loading = false;
              _salioError();
              notifyListeners();
              break;
            case FacebookLoginStatus.error:
              print('Error Login Facebook: ${result.errorMessage}');
              _loading = false;
              _salioError();
              notifyListeners();
              break;
          }
        });
        break;
      case 3: //google
        try {
          final GoogleSignInAccount googleUser =
              await _googleSignIn.signIn().catchError((e) {
            print(e);
          });

          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final AuthCredential credential = GoogleAuthProvider.getCredential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );
          _user = (await _auth.signInWithCredential(credential)).user;
        } on PlatformException catch (error) {
          print(error);
          _loading = false;
          _salioError();
          notifyListeners();
        }
        if (_user != null) {
          _prefs.setBool('isLoggedIn', true);
          _login = true;
          _loading = false;
          notifyListeners();
        } else {
          _error = true;
          _login = false;
          notifyListeners();
        }
        break;
      default:
    }
  }

  Future<String> loginWithEmail(String email, String pass) async {
    _error = false;
    _loading = true;
    final curretUser = await _auth
        .signInWithEmailAndPassword(email: email, password: pass)
        .then((FirebaseUser) async {
      _user = currentUser();
      if (_user != null) {
        _prefs.setBool('isLoggedIn', true);
        _login = true;
        _loading = false;
        notifyListeners();
      } else {
        _login = false;
        notifyListeners();
      }
      notifyListeners();
      return FirebaseUser.user.uid;
    }).catchError((e) {
      _salioError();
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
  }

  void backStep() {
    _stepPedido = _stepPedido - 1;
    notifyListeners();
  }

  void plusStep() {
    _stepPedido = _stepPedido + 1;
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

  void setStepPedido(int i) {
    _stepPedido = 0;
    notifyListeners();
  }

  ////////////////////////////UBICACIONES////////////////7

  
  bool _puntoa = false;
  bool _puntob = false;
  var _dira = null;
  var _dirb = null;
  
  
  void limpiarUbicacion(String s) {
    if (s == "a") {
      _dira = null;
      _puntoa = false;
    }
    if (s == "b") {
      _dirb = null;
      _puntob = false;
    }
    notifyListeners();
  }

  bool isPunto(String x) {
    if (x == "a") return _puntoa;
    if (x == "b") return _puntob;
  }

  void setUbicacion(String label, double lati, double longi, String punto) {
    if (punto == "a") {
      _dira = {
        "punto": punto,
        "label": label,
        "latitud": lati,
        "longitud": longi,
      };
      _puntoa = true;
    }
    if (punto == "b") {
      _dirb = {
        "punto": punto,
        "label": label,
        "latitud": lati,
        "longitud": longi,
      };
      _puntob = true;
    }
    notifyListeners();
  }

  String getDirecciondelPunto(String s) {
    if (s == "a") return _dira['label'].toString();    
    if (s == "b")  return _dirb['label'].toString();
  }
}
