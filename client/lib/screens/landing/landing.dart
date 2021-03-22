import 'package:client/utils/routeNames.dart';
import 'package:flutter/material.dart';

// TODO:
// Replace login and signup routes with dynamic widget switching
// - https://medium.com/codechai/switching-widgets-885d9b5b5c6f
// Replace form labels with widgets
// - https://medium.com/zipper-studios/the-keyboard-causes-the-bottom-overflowed-error-5da150a1c660
// Google sign on
// - https://medium.com/flutterdevs/google-sign-in-with-flutter-8960580dec96

class Landing extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget _buildCenter(context) {
      return Center(
        child: Container(
            width: 370,
            height: 320,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pantry Pal',
                  style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text('Join free today.', style: TextStyle(fontSize: 36)),
                SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('Log in pushed');
                        Navigator.pushNamed(context, RouteName.LOGIN);
                      },
                      child: Text('Log in'),
                    ))
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: ElevatedButton(
                      onPressed: () {
                        print('Sign up pushed');
                        Navigator.pushNamed(context, RouteName.SIGNUP);
                      },
                      child: Text('Sign up'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, // background
                        onPrimary: Colors.white, // foreground
                      ),
                    ))
                  ],
                ),
              ],
            ),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)))),
      );
    }

    return SafeArea(
        child: Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/BackgroundBlurred.jpg"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    _buildCenter(context),
                  ],
                ))));
  }
}
