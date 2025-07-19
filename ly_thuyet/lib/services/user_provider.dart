import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool get isLoggedIn => _token != null;

  // ✅ Load user từ SharedPreferences khi mở app
  Future<void> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user');
    if (userData != null) {
      final Map<String, dynamic> userMap = json.decode(userData);
      _username = userMap['username'];
      _email = userMap['email'];
      _avatarUrl = userMap['avatarUrl'];
      _fullName = userMap['fullName'];
      _token = userMap['token'];
      notifyListeners();
    }
  }

  // ✅ Lưu user vào SharedPreferences khi đăng nhập
  Future<void> setUser(String userName, String email, String avatarUrl, String fullName, String token) async {
    _username = userName;
    _email = email;
    _avatarUrl = avatarUrl;
    _fullName = fullName;
    _token = token;

    final prefs = await SharedPreferences.getInstance();
    final userMap = {
      'username': _username,
      'email': _email,
      'avatarUrl': _avatarUrl,
      'fullName': _fullName,
      'token': _token,
    };
    await prefs.setString('user', json.encode(userMap));

    notifyListeners();
  }

  // ✅ Xoá dữ liệu khi logout
  Future<void> clearUser() async {
    _username = null;
    _email = null;
    _avatarUrl = null;
    _fullName = null;
    _token = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');

    notifyListeners();
  }
}
