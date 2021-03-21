import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'screens/landing/landing.dart';

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pantry Pal',
      theme: ThemeData(
        // is not restarted.
        primarySwatch: Colors.purple,
      ),
      home: Landing(),
    );
  }
}
