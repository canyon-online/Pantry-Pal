import 'package:pantrypal/utils/AuthProvider.dart';
import 'package:pantrypal/utils/RouteNames.dart';
import 'package:pantrypal/utils/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GoogleSignIn extends StatefulWidget {
  @override
  GoogleSignInState createState() => GoogleSignInState();
}

class GoogleSignInState extends State<GoogleSignIn> {
  @override
  Widget build(BuildContext context) {
    var auth = Provider.of<AuthProvider>(context, listen: false);
    return InkWell(
        child: Container(
            width: 200,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), color: Colors.black),
            child: Center(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  height: 30.0,
                  width: 30.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/google.jpg'),
                        fit: BoxFit.cover),
                    shape: BoxShape.circle,
                  ),
                ),
                Text(
                  'Sign in with Google',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ],
            ))),
        onTap: () async {
          auth
              .googleLogin()
              .then((value) => {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(value['message']))),
                    if (value['status'] == true)
                      {
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(value['user']),
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.HOME, (_) => false)
                      }
                    else if (auth.verificationStatus != Status.Verified)
                      {
                        Provider.of<UserProvider>(context, listen: false)
                            .setUser(value['user']),
                        Navigator.pushNamedAndRemoveUntil(
                            context, RouteName.VERIFICATION, (_) => false)
                      }
                  })
              .catchError((error) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error.toString())))
                  });
        });
  }
}
