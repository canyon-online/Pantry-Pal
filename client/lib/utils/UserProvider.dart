import 'package:pantrypal/models/User.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  User _user = new User(userId: 'null', name: 'null', token: 'null');
  User get user => _user;

  void initializeUser(User user) {
    _user = user;
  }

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
