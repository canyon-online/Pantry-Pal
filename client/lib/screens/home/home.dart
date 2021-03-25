import 'package:flutter/material.dart';

class home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _home();
  }
}

class _home extends State<home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    Text(
      'Index 0: Home',
    ),
    Text(
      'Index 1: Add',
    ),
    Text(
      'Index 2: Search',
    ),
    Text(
      'Index 3: Profile I think?',
    ),
  ];
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child:const Text('Pantry Pal')),
      ),
      body: _children[_currentIndex], // new
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped, // new
        showUnselectedLabels: true,
        iconSize: 1,
        currentIndex: _currentIndex, // new
        items: [
          new BottomNavigationBarItem(
            icon: Icon(Icons.home),
            // ignore: deprecated_member_use
            title: Text('Home'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.add),
            // ignore: deprecated_member_use
            title: Text('Create'),
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.search),
              // ignore: deprecated_member_use
              title: Text('Search')
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              // ignore: deprecated_member_use
              title: Text('Username')
          )
        ],
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black38,
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[Text('Hello, user.')],
      ),
    )));
  }
}
*/