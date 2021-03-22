import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';

// Google sign in:
// import 'package:google_sign_in/google_sign_in.dart';

// GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [
//     'email',
//     'https://www.googleapis.com/auth/contacts.readonly',
//   ],
// );

// Future<void> _handleSignIn() async {
//   try {
//     await _googleSignIn.signIn();
//   } catch (error) {
//     print(error);
//   }
// }

extension Validator on String? {
  bool isValidEmail() {
    if (this == null) return false;
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this!);
  }

  bool isValidName() {
    if (this == null) return false;
    return RegExp(r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$').hasMatch(this!);
  }

  bool isValidPassword() {
    if (this == null) return false;
    return this!.length >= 8;
  }
}

var googleSignOn = InkWell(
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
      print('Google Sign On Tapped');
    });

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var signupLink = TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(2),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: Text('Sign up for Pantry Pal'),
    );

    var forgotPasswordLink = TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        // Navigator.pushNamed(context, '/forgotpassword');
        print('Forgot my password');
      },
      child: Text('Forgot my password'),
    );

    var fields = <Widget>[
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          hintText: 'Email or username',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          var empty = value?.isEmpty ?? true;
          if (empty) {
            return 'Please enter your email or username';
          } else if (!value.isValidEmail()) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
      TextFormField(
        textInputAction: TextInputAction.done,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          hintText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          var empty = value?.isEmpty ?? true;
          if (empty) {
            return 'Please enter your password';
          } else if (!value.isValidPassword()) {
            return 'Please enter a password with at least eight characters';
          }
          return null;
        },
      ),
      Text('Or'),
      googleSignOn,
      signupLink,
      forgotPasswordLink
    ];

    var center = Center(
        child: Container(
      width: 370,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InputBox('Log in to Pantry Pal', fields, _formKey),
    ));

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/BackgroundBlurred.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[center],
          ),
        ),
      ),
    );
  }
}
