import 'package:flutter/material.dart';
import '/services/user_secure_storage.dart';

class UserProvider with ChangeNotifier {
  String? _userID;
  String? _username;
  String? _email;
  String? _avatarUrl;
  String? _fullName;
  String? _token;

  String? get userID => _userID;
  String? get userName => _username;
  String? get email => _email;
  String? get avatarUrl => _avatarUrl;
  String? get fullName => _fullName;
  String? get token => _token;

  bool get isLoggedIn => _token != null;

  Future<void> loadUser() async {
    final userData = await UserSecureStorage.getUserInfo();
    _userID = userData['userID'];
    _username = userData['username'];
    _email = userData['email'];
    _avatarUrl = userData['avatarUrl'];
    _fullName = userData['fullName'];
    _token = userData['token'];
    notifyListeners();
  }

  // ✅ Lưu user vào UserSecureStorage khi đăng nhập
  Future<void> setUser(String userID, String userName, String email, String avatarUrl, String fullName, String token) async {
    _userID = userID;
    _username = userName;
    _email = email;
    _avatarUrl = avatarUrl;
    _fullName = fullName;
    _token = token;

    await UserSecureStorage.setUserInfo(
      userID: userID,
      username: userName,
      email: email,
      avatarUrl: avatarUrl,
      fullName: fullName,
      token: token,
    );
    notifyListeners();
  }

  // ✅ Xoá dữ liệu khi logout
  Future<void> clearUser() async {
    _userID = null;
    _username = null;
    _email = null;
    _avatarUrl = null;
    _fullName = null;
    _token = null;

    await UserSecureStorage.clearUserInfo();
    notifyListeners();
  }
}