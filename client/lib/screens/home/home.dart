import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/utils/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    if (AuthProvider().loggedInStatus != Status.LoggedIn) {
      Navigator.popUntil(context, ModalRoute.withName(RouteName.LANDING));
    }
    User user = Provider.of<UserProvider>(context).user;
    return SafeArea(
        child: Scaffold(
            body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Center(child: Text('Hello, ' + user.name))],
      ),
    )));
  }
}
