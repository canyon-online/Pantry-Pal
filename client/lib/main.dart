import 'package:flutter/material.dart';
import 'utils/routes.dart';

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
        onGenerateRoute: Routes.onGenerateRoute);
  }
}
