import 'package:client/utils/User.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreference {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('saved :' + user.userId + ', ' + user.name + ', ' + user.token + '.');
    prefs.setString('userId', user.userId);
    prefs.setString('name', user.name);

    return prefs.setString('token', user.token);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String userId = prefs.getString('userId') ?? 'null';
    String name = prefs.getString('name') ?? 'null';
    String token = prefs.getString('token') ?? 'null';
    print('fetched: ' + userId + ', ' + name + ', ' + token + '.');

    return User(userId: userId, name: name, token: token);
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove('userId');
    prefs.remove('name');
    prefs.remove('token');
  }

  Future<String> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? 'null';
    return token;
  }
}
