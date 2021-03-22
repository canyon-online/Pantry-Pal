import 'package:flutter/material.dart';
import 'package:client/screens/landing/landing.dart';
import 'package:client/screens/landing/signup.dart';
import 'package:client/screens/landing/login.dart';
import 'package:client/utils/routeNames.dart';

class Routes {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.LANDING:
        return MaterialPageRoute(builder: (context) => Landing());
      case RouteName.SIGNUP:
        return MaterialPageRoute(builder: (context) => Signup());
      case RouteName.LOGIN:
        return MaterialPageRoute(builder: (context) => Login());
      default:
        return MaterialPageRoute(
          builder: (context) => SafeArea(
            child: Scaffold(
              body: Center(
                child: Column(
                  children: <Widget>[Text('$settings.name not found')],
                ),
              ),
            ),
          ),
        );
    }
  }
}
