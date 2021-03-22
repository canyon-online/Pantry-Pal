import 'package:client/screens/landing/landing.dart';
import 'package:client/screens/landing/login.dart';
import 'package:client/screens/landing/signup.dart';
import 'package:client/screens/landing/forgotPassword.dart';
import 'package:flutter/material.dart';
import 'utils/routeNames.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pantry Pal',
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          accentColor: Colors.grey,
        ),
        initialRoute: '/',
        routes: {
          RouteName.LANDING: (context) => Landing(),
          RouteName.SIGNUP: (context) => Signup(),
          RouteName.LOGIN: (context) => Login(),
          RouteName.FORGOTPASSWORD: (context) => ForgotPassword()
        });
    // onGenerateRoute: Routes.onGenerateRoute);
  }
}
