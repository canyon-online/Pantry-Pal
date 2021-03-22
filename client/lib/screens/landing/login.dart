import 'package:client/utils/routeNames.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';
import 'package:client/utils/stringValidator.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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

Future<http.Response> loginUser(String email, String password) async {
  final response = await http.post(
    Uri.https('testing.hasty.cc', 'api/login'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, dynamic>{'email': email, 'password': password}),
  );

  if (response.statusCode == 200) {
    return response;
  } else {
    throw Exception('Failed to sign in user');
  }
}

class Login extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _login = TextEditingController();
  final TextEditingController _pass = TextEditingController();

  Widget _buildGoogleSignOn() {
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
          print('Google Sign On Tapped');
        });
  }

  Widget _buildSignupLink(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(2),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteName.SIGNUP);
      },
      child: Text('Sign up for Pantry Pal'),
    );
  }

  Widget _buildLoginField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: _login,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        hintText: 'Email or username',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please enter your email or username';
        } else if (!value.isValidEmail() && !value.isValidName()) {
          return 'Please enter a valid email or username';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      textInputAction: TextInputAction.done,
      obscureText: true,
      controller: _pass,
      enableSuggestions: false,
      autocorrect: false,
      decoration: const InputDecoration(
        contentPadding: EdgeInsets.only(left: 15.0),
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
    );
  }

  Widget _buildForgotPasswordLink(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(10),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        Navigator.pushNamed(context, RouteName.FORGOTPASSWORD);
        print('Forgot my password');
      },
      child: Text('Forgot my password'),
    );
  }

  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        if (validated) {
          loginUser(_login.text, _pass.text)
              .then((value) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value.body)))
                  })
              .catchError((error) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: error))
                  });
        }
      },
      child: Text('Next'),
    );
  }

  Widget _buildCenter(context) {
    return Center(
        child: Container(
      width: 370,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: InputBox(
          'Log in to Pantry Pal',
          <Widget>[
            _buildLoginField(),
            SizedBox(height: 10),
            _buildPasswordField(),
            SizedBox(height: 15),
            Text('Or'),
            SizedBox(height: 15),
            _buildGoogleSignOn(),
            SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
              _buildSignupLink(context),
              _buildForgotPasswordLink(context)
            ])
          ],
          _formKey,
          _buildSubmit(context)),
    ));
  }

  @override
  Widget build(BuildContext context) {
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
            children: <Widget>[_buildCenter(context)],
          ),
        ),
      ),
    );
  }
}
