import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class UserPreference {
  Future<bool> saveUser(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString('cookie', token);
  }

  Future<String?> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('cookie');
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('cookie');
  }
}
