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

class SignupForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignupFormState();
  }
}

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

class SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Email or username',
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
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              var validated = _formKey.currentState?.validate() ?? false;
              if (validated) {
                // If the form is valid, display a snackbar. In the real world,
                // you'd often call a server or save the information in a database.
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Logging in')));
              }
            },
            child: Text('Next'),
          )
        ],
      ),
    );
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
  @override
  Widget build(BuildContext context) {
    var signupLink = InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/signup');
      },
      child: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text('Sign up for Pantry Pal',
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );

    var forgotPassword = InkWell(
      onTap: () {
        // Navigator.pushNamed(context, '/signup');
        print('Forgot my password');
      },
      child: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text('Forgot my password',
            style: TextStyle(color: Theme.of(context).primaryColor)),
      ),
    );

    var center = Center(
      child: Container(
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Column(
            children: <Widget>[
              SignupForm(),
              Text('OR'),
              googleSignOn,
              signupLink,
              forgotPassword
            ],
          )),
    );

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
