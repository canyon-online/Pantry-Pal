import 'package:pantrypal/models/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreference {
  Future<bool> verifyUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('verified', true);
  }

  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', user.userId);
    prefs.setString('name', user.name);
    prefs.setBool('verified', user.verified);

    return prefs.setString('token', user.token);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString('userId') ?? 'null';
    String name = prefs.getString('name') ?? 'null';
    String token = prefs.getString('token') ?? 'null';
    bool verified = prefs.getBool('verified') ?? false;

    return User(userId: userId, name: name, token: token, verified: verified);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
    prefs.remove('name');
    prefs.remove('token');
    prefs.remove('verified');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'null';
    return token;
  }
}
