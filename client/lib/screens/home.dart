import 'package:client/screens/landing.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/views/CreateView.dart';
import 'package:client/views/HomeView.dart';
import 'package:client/views/ProfileView.dart';
import 'package:client/views/SearchView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  int _currentIndex = 0;

  final List<Widget> _children = [
    HomeView(),
    CreateView(),
    SearchView(),
    ProfileView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, auth, child) =>
            auth.verificationStatus == Status.Verified
                ? SafeArea(
                    child: Scaffold(
                    appBar: AppBar(
                      title: const Text('Pantry Pal'),
                    ),
                    body: _children[_currentIndex],
                    drawer: Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: <Widget>[
                          DrawerHeader(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Text(
                              'Pantry Pal',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          ListTile(
                            title: Text('Home'),
                            onTap: () {
                              onTabTapped(0);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text('Search'),
                            onTap: () {
                              onTabTapped(2);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text('Create'),
                            onTap: () {
                              onTabTapped(1);
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            title: Text('Profile'),
                            onTap: () {
                              onTabTapped(3);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                  ))
                : Landing());
  }
}
