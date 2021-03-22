import 'package:flutter/material.dart';
import 'screens/landing/landing.dart';
import 'screens/landing/signup.dart';
import 'screens/landing/login.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pantry Pal',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        // home: Landing(),
        initialRoute: '/',
        routes: {
          '/': (context) => Landing(),
          '/signup': (context) => Signup(),
          '/login': (context) => Login(),
        });
  }
}
