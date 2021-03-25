// AuthProvider
// CODE AND INSPIRATION FROM
// https://medium.com/@afegbua/flutter-thursday-13-building-a-user-registration-and-login-process-with-provider-and-external-api-1bb87811fd1d
// THANK YOU SHUAIB AFEGBUA

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:client/utils/UserPreference.dart';

// TODO: REPLACE API LINKS WITH CONSTANTS

enum Status {
  Authenticating,
  LoggedIn,
  LoggedOut,
  NotLoggedIn,
  Registering,
  Registered,
  NotRegistered
}

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

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;
  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;

  void saveLogin(String token) {
    print('Saved token ' + token);
    UserPreference().saveUser(token);
  }

  // API call to login a user and save login info.
  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    final Map<String, dynamic> loginData = {
      'email': email,
      'password': password
    };

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    Response response = await http.post(
      Uri.https('testing.hasty.cc', 'api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(loginData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200 && responseData['error'] == null) {
      print(responseData);
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {'status': true, 'message': 'Successfully logged in'};
    } else {
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': responseData['error']};
    }

    return result;
  }

  // API call to signup a user and save login info.
  Future<Map<String, dynamic>> signup(
      String name, String email, String password) async {
    var result;

    final Map<String, dynamic> signupData = {
      'name': name,
      'email': email,
      'password': password
    };

    _registeredStatus = Status.Registering;
    notifyListeners();

    final response = await http.post(
      Uri.https('testing.hasty.cc', 'api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(signupData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _registeredStatus = Status.Registered;
      _loggedInStatus = Status.LoggedIn;
      notifyListeners();
      result = {
        'status': true,
        'message': 'Successfully registered and logged in'
      };
    } else {
      _registeredStatus = Status.NotRegistered;
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': responseData['error']};
    }

    return result;
  }
}
