// AuthProvider
// CODE AND INSPIRATION FROM
// https://medium.com/@afegbua/flutter-thursday-13-building-a-user-registration-and-login-process-with-provider-and-external-api-1bb87811fd1d
// THANK YOU SHUAIB AFEGBUA

import 'dart:async';
import 'dart:convert';
import 'package:client/models/User.dart';
import 'package:client/utils/API.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

// Helper function to return the decoded base 64 string.
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

// Returns the middle section of a JWT containing mostly the user data
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
  set loggedInStatus(value) => _loggedInStatus = value;
  set registeredStatus(value) => _registeredStatus = value;
  set verificationStatus(value) => _verificationStatus = value;

  // Saves login data given a response's token
  User saveLogin(Map<String, dynamic> responseData) {
    var userData = parseJwt(responseData['token']);
    userData['token'] = responseData['token'];
    User authUser = User.fromMap(userData);
    UserPreference().saveUser(authUser);
    return authUser;
  }

  // Helper function to perform login after an API call. Mostly checks response
  // codes, sets AuthProvider state, and such.
  Map<String, dynamic> _login(Map<String, dynamic> responseData) {
    var result;

    // If there was no issue with registering or verifying...
    if (responseData['code'] == 200 && responseData['error'] == null) {
      User user = saveLogin(responseData);

      if (user.verified) {
        // User is verified
        _loggedInStatus = Status.LoggedIn;
        _verificationStatus = Status.Verified;
        _registeredStatus = Status.Registered;
        result = {
          'status': true,
          'message': 'Successfully logged in',
          'user': user
        };
      } else {
        // User is not verified
        _loggedInStatus = Status.NotLoggedIn;
        _verificationStatus = Status.Verifying;
        _registeredStatus = Status.Registered;

        result = {
          'status': false,
          'message': 'Please verify your account',
          'user': user
        };
      }
    } else {
      // There was likely some error with the API call if we get here
      _loggedInStatus = Status.NotLoggedIn;
      result = {
        'status': false,
        'code': responseData['code'],
        'message': responseData['error']
      };
    }

    return result;
  }

  // Call to perform entire google login & sign up
  Future<Map<String, dynamic>> googleLogin() async {
    var result;
    GoogleSignInAccount? account;
    GoogleSignInAuthentication googleSignInAuthentication;
    GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

    // Attempt fetching a google account
    try {
      account = await _googleSignIn.signIn();
      // Grab the authentication details and update state of the provider
      googleSignInAuthentication = await account!.authentication;
      _loggedInStatus = Status.Authenticating;
      notifyListeners();
    } catch (e, stacktrace) {
      // Failed to select an account
      _loggedInStatus = Status.NotLoggedIn;
      notifyListeners();
      print(stacktrace.toString());
      return {'status': false, 'message': 'Failed to complete google sign in'};
    }

    // Handle responses
    try {
      // Call to the API to sign up and/or login.
      final Map<String, dynamic> responseData = await API()
          .googleVerification(googleSignInAuthentication.idToken.toString());
      result = _login(responseData);
    } catch (on, stacktrace) {
      result = {'status': false, 'message': stacktrace.toString()};
    }

    return result;
  }

  // API call to login a user and save login info.
  Future<Map<String, dynamic>> login(String email, String password) async {
    var result;

    _loggedInStatus = Status.Authenticating;
    notifyListeners();

    try {
      final Map<String, dynamic> responseData =
          await API().doLogin(email, password);
      result = _login(responseData);
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

    _verificationStatus = Status.NotVerified;
    _registeredStatus = Status.Registering;
    _loggedInStatus = Status.NotLoggedIn;
    notifyListeners();

    try {
      final Map<String, dynamic> responseData =
          await API().doSignup(name, email, password);

      switch (responseData['code']) {
        case 200:
          _verificationStatus = Status.NotVerified;
          _registeredStatus = Status.Registered;
          _loggedInStatus = Status.NotLoggedIn;
          result = {
            'status': true,
            'message': 'Successfully registered, please verify your account',
            'user': saveLogin(responseData)
          };
          break;
        default:
          _verificationStatus = Status.NotVerified;
          _registeredStatus = Status.NotRegistered;
          _loggedInStatus = Status.NotLoggedIn;
          result = {'status': false, 'message': responseData['error']};
      }
    } catch (on, stacktrace) {
      _verificationStatus = Status.NotVerified;
      _registeredStatus = Status.NotRegistered;
      _loggedInStatus = Status.NotLoggedIn;
      result = {'status': false, 'message': stacktrace.toString()};
    }

    notifyListeners();
    return result;
  }

  Future<Map<String, dynamic>> verify(String code, String token) async {
    var result;

    _verificationStatus = Status.Verifying;
    notifyListeners();

    try {
      final Map<String, dynamic> responseData =
          await API().checkVerification(token, code);

      switch (responseData['code']) {
        case 200: // Successful verification
          UserPreference().verifyUser();
          _loggedInStatus = Status.LoggedIn;
          _verificationStatus = Status.Verified;
          _registeredStatus = Status.Registered;
          result = {
            'status': true,
            'message': 'Sucessfully verified and logged in'
          };
          break;
        case 400: // Code timed out
          _loggedInStatus = Status.NotLoggedIn;
          _verificationStatus = Status.NotVerified;
          _registeredStatus = Status.Registered;
          result = {
            'status': false,
            'message': 'Failed to verify: entered an expired code'
          };
          break;
        case 422: // Invalid code responseData
          print(responseData);
          result = {
            'status': false,
            'message': 'Failed to verify: invalid code'
          };
          break;
        default:
          result = {'status': false, 'message': responseData.toString()};
      }
    } catch (on, stacktrace) {
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
