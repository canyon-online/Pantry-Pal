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
    // MaterialApp is the main app being run. There should only exist one for
    // each project.
    return MaterialApp(
        title: 'Pantry Pal',

        // The ThemeData allows our widgets to use default colors. Change this
        // depending on how we want the project to look.
        theme: ThemeData(
          // PrimarySwatch and color mostly deal with how text vs. buttons are colored.
          primarySwatch: Colors.deepPurple,
          primaryColor: Colors.deepPurple,
          accentColor: Colors.grey,
        ),

        // Start the app on the landing page. This could be made conditional
        // depending on the state of the login.
        initialRoute: RouteName.LANDING,

        // Routes are used for app and web navigation. For example,
        // hitting the back button returns to the previous route.
        routes: {
          RouteName.LANDING: (context) => Landing(),
          RouteName.SIGNUP: (context) => Signup(),
          RouteName.LOGIN: (context) => Login(),
          RouteName.FORGOTPASSWORD: (context) => ForgotPassword()
        });
  }
}
