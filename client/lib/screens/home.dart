import 'package:client/models/User.dart';
import 'package:client/screens/landing.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/CreateView.dart';
import 'package:client/widgets/HomeView.dart';
import 'package:client/widgets/ProfileView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeView(),
    CreateView(),
    Text('Index 2: Search'),
    ProfileView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    // Hacky way of forcing people to login is to display the login screen if the
    // app is not logged in...
    return auth.loggedInStatus == Status.LoggedIn
        ? SafeArea(
            child: Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: Center(child: const Text('Pantry Pal')),
            ),
            body: _children[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: onTabTapped,
              showUnselectedLabels: true,
              iconSize: 1,
              currentIndex: _currentIndex,
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
                    icon: Icon(Icons.person), label: 'Profile')
              ],
              selectedItemColor: Colors.black,
              unselectedItemColor: Colors.black38,
            ),
          ))
        : Landing();
  }
}
