import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String? _username;
  String? _email;
  String? _avatarUrl;
  String? _fullName;
  String? _token;

  String? get userName => _username;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;
  String? get fullName => _fullName;
  String? get token => _token;

  void setUser(String userName, String email, String avatarUrl, String fullName, String token) {
    _username = userName;
    _email = email;
    _avatarUrl = avatarUrl;
    _fullName = fullName;
    _token = token;
    notifyListeners();
  }

  bool get isLoggedIn => _token != null;

  void clearUser() {
    _username = '';
    _email = '';
    _avatarUrl = '';
    _fullName = '';
    notifyListeners();
  }
}
