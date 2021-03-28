// AuthProvider
// CODE AND INSPIRATION FROM
// https://medium.com/@afegbua/flutter-thursday-13-building-a-user-registration-and-login-process-with-provider-and-external-api-1bb87811fd1d
// THANK YOU SHUAIB AFEGBUA

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:client/utils/UserPreference.dart';

enum Status {
  // _verificationStatus
  NotVerified,
  Verifying,
  Verified,

  // _loggedInStatus
  LoggedIn,
  Authenticating,
  LoggedOut,
  NotLoggedIn,

  // _registeredStatus
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

Map<String, dynamic> parseJwt(String token) {
  final parts = token.split('.');
  final payload = _decodeBase64(parts[1]);
  final payloadMap = json.decode(payload);
  return payloadMap;
}

class AuthProvider with ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registeredStatus = Status.NotRegistered;
  Status _verificationStatus = Status.NotVerified;
  Status get loggedInStatus => _loggedInStatus;
  Status get registeredStatus => _registeredStatus;
  Status get verificationStatus => _verificationStatus;

  User saveLogin(Map<String, dynamic> responseData) {
    var userData = parseJwt(responseData['token']);
    userData['token'] = responseData['token'];
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

    // _verificationStatus = Status.NotVerified;
    // _registeredStatus = Status.Registering;
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
        User user = saveLogin(responseData);
        if (user.verified == false) {
          print('user is not verified');
          _loggedInStatus = Status.NotLoggedIn;
          _verificationStatus = Status.Verifying;
          _registeredStatus = Status.Registered;
          result = {
            'status': false,
            'message': 'Please verify your account',
            'user': user
          };
        } else {
          print('user is verified');
          _loggedInStatus = Status.LoggedIn;
          _verificationStatus = Status.Verified;
          _registeredStatus = Status.Registered;
          result = {
            'status': true,
            'message': 'Successfully logged in',
            'user': user
          };
        }
      } else {
        _loggedInStatus = Status.NotLoggedIn;
        result = {'status': false, 'message': responseData['error']};
      }
    } catch (on, stacktrace) {
      result = {'status': false, 'message': stacktrace.toString()};
    }

    notifyListeners();
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

    _verificationStatus = Status.NotVerified;
    _registeredStatus = Status.Registering;
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();

    final response = await http.post(
      Uri.https(API.baseURL, API.signup),
      headers: API.postHeader,
      body: jsonEncode(signupData),
    );

    final Map<String, dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      _verificationStatus = Status.NotVerified;
      _registeredStatus = Status.Registered;
      _loggedInStatus = Status.NotLoggedIn;
      result = {
        'status': true,
        'message': 'Successfully registered, please verify your account',
        'user': saveLogin(responseData)
      };
    } else {
      _verificationStatus = Status.NotVerified;
      _registeredStatus = Status.NotRegistered;
      _loggedInStatus = Status.NotLoggedIn;
      result = {'status': false, 'message': responseData['error']};
    }

    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> verify(String code, String token) async {
    var result;
    final Map<String, dynamic> verifyData = {'code': code};

    _verificationStatus = Status.Verifying;
    notifyListeners();

    Response response = await http.post(Uri.https(API.baseURL, API.verify),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: 'bearer ' + token
        },
        body: jsonEncode(verifyData));

    final Map<String, dynamic> responseData = json.decode(response.body);
    try {
      if (response.statusCode == 200) {
        UserPreference().verifyUser();
        _loggedInStatus = Status.LoggedIn;
        _verificationStatus = Status.Verified;
        _registeredStatus = Status.Registered;
        result = {
          'status': true,
          'message': 'Sucessfully verified and logged in'
        };
      } else if (response.statusCode == 410) {
        // Code timed out
        _loggedInStatus = Status.NotLoggedIn;
        _verificationStatus = Status.NotVerified;
        _registeredStatus = Status.Registered;
        result = {
          'status': false,
          'message': 'Failed to verify: entered an expired code'
        };
      } else if (response.statusCode == 422) {
        // Invalid coderesponseData
        print(response.body);
        result = {'status': false, 'message': 'Failed to verify: invalid code'};
      } else {
        // Something bad happened
        result = {'status': false, 'message': responseData.toString()};
      }
    } catch (on, stacktrace) {
      print(response.body.toString());
      result = {'status': false, 'message': stacktrace.toString()};
    }

    notifyListeners();
    return result;
  }

  void logout() {
    UserPreference().removeUser();
    _loggedInStatus = Status.NotLoggedIn;
    _registeredStatus = Status.NotRegistered;
    _verificationStatus = Status.NotVerified;
    notifyListeners();
  }
}
