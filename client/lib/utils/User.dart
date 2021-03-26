import 'package:flutter/material.dart';

class User {
  String userId;
  String name;
  String token;

  User({required this.userId, required this.name, required this.token});

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
        userId: data['userId'] ?? 'NULL',
        name: data['name'] ?? 'NULL',
        token: data['token'] ?? 'NULL');
  }
}

class UserProvider with ChangeNotifier {
  User _user = new User(userId: 'null', name: 'null', token: 'null');
  User get user => _user;

  void setUser(User user) {
    print('Set user to ' + user.name);
    _user = user;
    notifyListeners();
  }
}
