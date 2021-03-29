import 'dart:io';

import 'package:client/models/User.dart';
import 'package:client/screens/landing.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/AuthProvider.dart';
import 'package:client/utils/RouteNames.dart';
import 'package:client/utils/UserProvider.dart';
import 'package:client/widgets/InputBox.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Verification extends StatefulWidget {
  @override
  VerificationState createState() => new VerificationState();
}

class VerificationState extends State<Verification> {
  final _formKey = GlobalKey<FormState>();
  final _verify = TextEditingController();

  // Function to build and return a login field text box.
  Widget _buildVerificationField() {
    return TextFormField(
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.number,
      // Be sure to pass in the text controller to fields to grab their text.
      controller: _verify,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Verification code',
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.only(left: 15.0),
      ),
      validator: (value) {
        if (value?.isEmpty ?? true)
          return 'Please enter your verification code';
        return null;
      },
    );
  }

  Future<Map<String, dynamic>> handleRequestCode(context) async {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    var result;

    final response = await http.post(
      Uri.https(API.baseURL, API.requestVerify),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'bearer ' + user.token
      },
    );

    try {
      if (response.statusCode == 200) {
        result = {'status': true, 'message': 'Sent a new verification email'};
      } else {
        result = {
          'status': false,
          'message': 'Failed to send a new verification email'
        };
      }
    } catch (on, stacktrace) {
      print(stacktrace.toString());
      result = {
        'status': false,
        'message': 'Failed to send a new verification email'
      };
    }

    return result;
  }

  Widget _buildRequestCode(context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(2),
        shape: const BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5))),
      ),
      onPressed: () {
        handleRequestCode(context).then(
          (value) => ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(value['message']))),
        );
      },
      child: Text('Request a new verification code'),
    );
  }

  void handleSubmit(context) {
    User user = Provider.of<UserProvider>(context, listen: false).user;
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);

    auth
        .verify(_verify.text, user.token)
        .then((value) => {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(value['message']))),
              if (value['status'] == true)
                {
                  Navigator.pushNamedAndRemoveUntil(
                      context, RouteName.HOME, (_) => false)
                }
            })
        .catchError((error) => {
              print(error),
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(error.toString())))
            });
  }

  // Function to build and return a form submit button. This is critical to the
  // implementation of the InputBox class.
  Widget _buildSubmit(context) {
    return ElevatedButton(
      onPressed: () {
        var validated = _formKey.currentState?.validate() ?? false;
        if (validated) handleSubmit(context);
      },
      child: Text('Verify'),
    );
  }

  // Function called to build the widget in the center.
  Widget _buildCenter(context) {
    return Center(
      child: Container(
          width: 370,
          padding: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: InputBox(
              'Verify your account',
              <Widget>[
                _buildVerificationField(),
                _buildRequestCode(context),
                // request a new code button
              ],
              _formKey,
              _buildSubmit(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<UserProvider>(context).user;
    AuthProvider auth = Provider.of<AuthProvider>(context);

    print(auth.loggedInStatus);
    print(auth.verificationStatus);
    print(auth.registeredStatus);

    return auth.verificationStatus != Status.Verified
        ? SafeArea(
            child: Scaffold(
            body: Container(
              // Background image. I'm a bit annoyed how each screen reloads it.
              // Bounty for whoever can fix that
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
          ))
        : Landing();
  }
}
