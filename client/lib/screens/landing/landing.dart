import 'package:flutter/material.dart';

var signupButton = ElevatedButton(
  onPressed: () {
    print('Sign up pushed');
  },
  child: Text('Sign up'),
  style: ElevatedButton.styleFrom(
    primary: Colors.grey, // background
    onPrimary: Colors.white, // foreground
  ),
);

var loginButton = ElevatedButton(
  onPressed: () {
    print('Log in pushed');
  },
  child: Text('Log in'),
);

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var center = Center(
      child: Container(
          child: Column(
            children: <Widget>[
              Text(
                'Pantry Pal',
                style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
              ),
              Text('Join free today.', style: TextStyle(fontSize: 36)),
              Row(
                children: <Widget>[Expanded(child: loginButton)],
              ),
              Row(
                children: <Widget>[Expanded(child: signupButton)],
              ),
            ],
          ),
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)))),
    );

    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    center,
                  ],
                ))));
  }
}
