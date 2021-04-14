import 'package:client/screens/landing.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/views/CreateView.dart';
import 'package:client/views/FavoriteView.dart';
import 'package:client/views/HomeView.dart';
import 'package:client/views/ProfileView.dart';
import 'package:client/views/RecipeView.dart';
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
    RecipeView(),
    FavoriteView(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _buildDrawerHeader(String token) {
    return FutureBuilder(
      future: API().getUserInfo(token),
      builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Padding(
                padding: EdgeInsets.all(10),
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.green,
                  ),
                  child: Text(
                    'Pantry Pal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                    ),
                  ),
                ));
          default:
            if (snapshot.hasError)
              return DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Text(
                  'Pantry Pal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                  ),
                ),
              );
            else {
              var data = Map.from(snapshot.data!);
              return UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                accountEmail: Text(data['email']),
                accountName: Text(data['display']),
                currentAccountPicture: Text(
                  'Pantry Pal',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              );
            }
        }
      },
    );
  }

  Widget _drawDrawer(String token) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          _buildDrawerHeader(token),
          ListTile(
            title: Text('Home'),
            leading: Icon(Icons.home),
            onTap: () {
              onTabTapped(0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Search'),
            leading: Icon(Icons.search),
            onTap: () {
              onTabTapped(2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Create'),
            leading: Icon(Icons.create),
            onTap: () {
              onTabTapped(1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Profile'),
            leading: Icon(Icons.person),
            onTap: () {
              onTabTapped(3);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Favorites'),
            leading: Icon(Icons.favorite),
            onTap: () {
              onTabTapped(4);
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Recipes'),
            leading: Icon(Icons.food_bank),
            onTap: () {
              onTabTapped(5);
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
        builder: (context, auth, child) =>
            auth.verificationStatus == Status.Verified
                ? SafeArea(
                    child: Scaffold(
                        appBar: AppBar(
                          title: Text('Pantry Pal'),
                        ),
                        body: _children[_currentIndex],
                        drawer: _drawDrawer(
                            Provider.of<UserProvider>(context, listen: false)
                                .user
                                .token)))
                : Landing());
  }
}
