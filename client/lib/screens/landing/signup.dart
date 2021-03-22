import 'package:flutter/material.dart';
import 'package:client/widgets/InputBox.dart';

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

extension StringValidator on String? {
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
              'Sign up with Google',
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

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController _pass = TextEditingController();
    final TextEditingController _confirmPass = TextEditingController();

    var fields = <Widget>[
      TextFormField(
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0),
          border: OutlineInputBorder(),
          // icon: Icon(Icons.person),
          hintText: 'Name',
          // labelText: 'Name *',
        ),
        validator: (value) {
          var empty = value?.isEmpty ?? true;
          if (empty) {
            return 'Please enter your name';
          } else if (!value.isValidName()) {
            return 'Please enter a valid name';
          }
          return null;
        },
      ),
      SizedBox(height: 10),
      TextFormField(
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0),
          border: OutlineInputBorder(),
          hintText: 'Email',
        ),
        validator: (value) {
          var empty = value?.isEmpty ?? true;
          if (empty) {
            return 'Please enter your email';
          } else if (!value.isValidEmail()) {
            return 'Please enter a valid email';
          }
          return null;
        },
      ),
      SizedBox(height: 10),
      TextFormField(
        textInputAction: TextInputAction.next,
        controller: _pass,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0),
          border: OutlineInputBorder(),
          hintText: 'Password',
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
      SizedBox(height: 10),
      TextFormField(
        textInputAction: TextInputAction.done,
        controller: _confirmPass,
        obscureText: true,
        enableSuggestions: false,
        autocorrect: false,
        decoration: const InputDecoration(
          contentPadding: EdgeInsets.only(left: 15.0),
          border: OutlineInputBorder(),
          hintText: 'Confirm password',
          // labelText: 'Name *',
        ),
        // The validator receives the text that the user has entered.
        validator: (value) {
          var empty = value?.isEmpty ?? true;
          if (empty) {
            return 'Please confirm your password';
          } else if (value != _pass.text) {
            return 'Passwords do not match';
          }
          return null;
        },
      ),
      SizedBox(height: 15),
      Text('Or'),
      SizedBox(height: 15),
      googleSignOn
    ];

    var center = Center(
      child: Container(
          width: 370,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InputBox('Create your account', fields, _formKey)),
    );

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
            children: <Widget>[center],
          ),
        ),
      ),
    );
  }
}
