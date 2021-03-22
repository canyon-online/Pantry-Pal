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

enum Step { email, verification, login }

Future<http.Response> emailUser(String email) async {
  final response = await http.post(
    Uri.https('jsonplaceholder.typicode.com', 'posts'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
    body: jsonEncode(<String, String>{'email': email}),
  );

  if (response.statusCode == 201) {
    return response;
  } else {
    throw Exception('Failed to email user');
  }
}

class ForgotPasswordState extends State<ForgotPassword> {
  final _formKeyEmail = GlobalKey<FormState>();
  final _formKeyVerification = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _verification = TextEditingController();
  Step selectedStep = Step.email;

  Widget _buildEmailField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Email',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
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
    );
  }

  Widget _buildVerificationField() {
    return TextFormField(
      controller: _verification,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Verification',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        var empty = value?.isEmpty ?? true;
        if (empty) {
          return 'Please your verification code';
        }
        return null;
      },
    );
  }

  void handleSubmit() {
    switch (selectedStep) {
      case Step.email:
        var validated = _formKeyEmail.currentState?.validate() ?? false;
        if (validated) {
          emailUser(_email.text)
              .then((value) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value.body)))
                  })
              .catchError((error) => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(error)))
                  });
          setState(() {
            selectedStep = Step.verification;
          });
        }
        break;
      case Step.verification:
        var validated = _formKeyVerification.currentState?.validate() ?? false;
        if (validated) {
          setState(() {
            selectedStep = Step.login;
          });
        }
        break;
      case Step.login:
        // TODO: Handle this case.
        break;
    }
  }

  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        handleSubmit();
      },
      child: Text('Next'),
    );
  }

  Widget _buildInputBox(context) {
    switch (selectedStep) {
      case Step.email:
        return InputBox(
            'Find your Pantry Pal account',
            <Widget>[
              _buildEmailField(),
              SizedBox(height: 10),
            ],
            _formKeyEmail,
            _buildSubmit(context));
      case Step.verification:
        return InputBox(
            'Enter verification',
            <Widget>[
              _buildVerificationField(),
              SizedBox(height: 10),
            ],
            _formKeyVerification,
            _buildSubmit(context));
      case Step.login:
        return InputBox(
            'Enter verification',
            <Widget>[
              _buildVerificationField(),
              SizedBox(height: 10),
            ],
            _formKeyVerification,
            _buildSubmit(context));
    }
  }

  Widget _buildCenter(context) {
    return Center(
        child: Container(
      width: 370,
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: _buildInputBox(context),
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

class ForgotPassword extends StatefulWidget {
  State<StatefulWidget> createState() => ForgotPasswordState();
}
