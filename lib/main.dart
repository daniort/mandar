import 'package:flutter/material.dart';
import 'package:mandadero/Router/strings.dart';
import 'package:mandadero/cliente/principal_wid.dart';
import 'package:mandadero/repartidor/principal_repartidor.dart';
import 'package:mandadero/screens/first_page.dart';
import 'package:mandadero/screens/login.dart';
import 'package:mandadero/state/loginstate.dart';
import 'package:provider/provider.dart';
import 'Router/generateRouter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginState>(
      create: (BuildContext context) => LoginState(),
      child: MaterialApp(
        
        onGenerateRoute: Router().generateRoute,

        initialRoute: mainRoute,
        title: "Mandadeos App",
        routes: {
          mainRoute: (BuildContext context) {
            var _state = Provider.of<LoginState>(context);
            if (_state.islogin()) {
              switch (_state.isType_User()) {
                case 1:
                  return ProfileCliente();
                  break;
                case 2:
                  return ProfileMandadero();
                  break;
                default:
              }
            } else {
              switch (_state.isLogin_Step()) {
                case 1:
                  return FirtsPage();
                  break;
                case 2:
                  return Login();
                  break;
                default:
              }
            }
          }
        },
      ),
    );
  }
}
  
