import 'package:client/screens/landing/landing.dart';
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
    User user = Provider.of<UserProvider>(context).user;
    int _currentIndex = 0;

    final List<Widget> _children = [
      Text('Index 0: Home'),
      Text('Index 1: Add'),
      Text('Index 2: Search'),
      Text('Index 3: Profile I think?'),
    ];

    void onTabTapped(int index) {
      setState(() {
        _currentIndex = index;
      });
    }

    // Hacky way of forcing people to login is to display the login screen if the
    // app is not logged in...
    return AuthProvider().loggedInStatus != Status.LoggedIn
        ? SafeArea(
            child: Scaffold(
            appBar: AppBar(
              title: Center(child: const Text('Pantry Pal')),
            ),
            body: _children[_currentIndex], // new
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped, // new
              showUnselectedLabels: true,
              iconSize: 1,
              currentIndex: _currentIndex, // new
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Create',
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.search), label: 'Search'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: user.name)
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black38,
            ),
          ))
        : Landing();
  }
}
