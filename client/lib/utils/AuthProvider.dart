// AuthProvider
// CODE AND INSPIRATION FROM
// https://medium.com/@afegbua/flutter-thursday-13-building-a-user-registration-and-login-process-with-provider-and-external-api-1bb87811fd1d
// THANK YOU SHUAIB AFEGBUA

import 'dart:async';
import 'dart:convert';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:client/utils/User.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:client/utils/UserPreference.dart';

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

  Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    return payloadMap;
  }

  String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  User saveLogin(Map<String, dynamic> responseData) {
    var userData = parseJwt(responseData['token']);
    userData['token'] = responseData['token'];
    print(userData);
    User authUser = User.fromMap(userData);
    print('New user created in saveLogin: ' + authUser.name);
    UserPreference().saveUser(authUser);
    return authUser;
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
      Uri.https(API.baseURL, API.login),
      headers: API.postHeader,
      body: jsonEncode(loginData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    try {
      if (response.statusCode == 200 && responseData['error'] == null) {
        _loggedInStatus = Status.LoggedIn;
        result = {
          'status': true,
          'message': 'Successfully logged in',
          'user': saveLogin(responseData)
        };
        notifyListeners();
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        notifyListeners();
        result = {'status': false, 'message': responseData['error']};
      }
    } catch (on, stacktrace) {
      result = {'status': false, 'message': stacktrace.toString()};
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
      Uri.https(API.baseURL, API.signup),
      headers: API.postHeader,
      body: jsonEncode(signupData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _registeredStatus = Status.Registered;
      _loggedInStatus = Status.LoggedIn;
      result = {
        'status': true,
        'message': 'Successfully registered and logged in',
        'user': saveLogin(responseData)
      };
      notifyListeners();
    } else {
      _registeredStatus = Status.NotRegistered;
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      result = {'status': false, 'message': responseData['error']};
    }
    return result;
  }

  void logout() {
    UserPreference().removeUser();
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();
  }
}
