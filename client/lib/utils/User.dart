import 'package:client/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _user = new User(userId: 'null', name: 'null', token: 'null');
  User get user => _user;

  void setUser(User user) {
    print('Set user to ' + user.name);
    _user = user;
    notifyListeners();
  }
}
