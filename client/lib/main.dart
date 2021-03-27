import 'package:client/screens/home/home.dart';
import 'package:client/screens/landing/landing.dart';
import 'package:client/screens/landing/login.dart';
import 'package:client/screens/landing/signup.dart';
import 'package:client/screens/landing/forgotPassword.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/User.dart';
import 'package:client/utils/UserPreference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/User.dart';
import 'utils/RouteNames.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserPreference().removeUser(); // comment/uncomment this line
    Future<User> getUserData() => UserPreference().getUser();

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => UserProvider())
        ],
        child:
            // MaterialApp is the main app being run. There should only exist one for
            // each project.
            MaterialApp(
                title: 'Pantry Pal',

                // The ThemeData allows our widgets to use default colors. Change this
                // depending on how we want the project to look.
                theme: ThemeData(
                  // PrimarySwatch and color mostly deal with how text vs. buttons are colored.
                  primarySwatch: Colors.green,
                  primaryColor: Colors.green,
                  accentColor: Colors.grey,
                ),

                // Start the app on the landing page. This could be made conditional
                // depending on the state of the login.
                // initialRoute: RouteName.HOME,
                home: FutureBuilder(
                    future: getUserData(),
                    builder: (context, AsyncSnapshot<User> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                          return CircularProgressIndicator();
                        default:
                          if (snapshot.hasError)
                            return Text('Error: ${snapshot.error}');
                          else if ((snapshot.data?.token ?? 'null') == 'null') {
                            UserPreference().removeUser();
                            return Landing();
                          }
                          return Home();
                      }
                    }),

                // home: loginFuture,
                // Routes are used for app and web navigation. For example,
                // hitting the back button returns to the previous route.
                routes: {
              RouteName.LANDING: (context) => Landing(),
              RouteName.SIGNUP: (context) => Signup(),
              RouteName.LOGIN: (context) => Login(),
              RouteName.FORGOTPASSWORD: (context) => ForgotPassword(),
              RouteName.HOME: (context) => Home(),
            }));
  }
}
