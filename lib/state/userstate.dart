import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';


class UserState with ChangeNotifier {
    int _tipeuser = 0;
  int _first = 0;

  int isTipe() => _tipeuser;
  isfirst() => _first;

   void type(int n) async {
    if (n == 1) {
      // cliente
      
      _tipeuser = 1;
      
    } else {
      // mandadero
      
      _tipeuser = 2;
      
    }
  }


}