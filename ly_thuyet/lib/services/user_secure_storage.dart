import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserSecureStorage {
  static const _storage = FlutterSecureStorage();

  static const _keyUserID = 'userID';
  static const _keyUsername = 'username';
  static const _keyEmail = 'email';
  static const _keyAvatarUrl = 'avatarUrl';
  static const _keyFullName = 'fullName';
  static const _keyToken = 'token';

  static Future<void> setUserInfo({
    required String userID,
    required String username,
    required String email,
    required String avatarUrl,
    required String fullName,
    String token = '',
  }) async {
    print('Saving to SecureStorage - userID: $userID, username: $username, fullName: $fullName, token: $token');
    await _storage.write(key: _keyUserID, value: userID);
    await _storage.write(key: _keyUsername, value: username);
    await _storage.write(key: _keyEmail, value: email);
    await _storage.write(key: _keyAvatarUrl, value: avatarUrl);
    await _storage.write(key: _keyFullName, value: fullName);
    await _storage.write(key: _keyToken, value: token);
  }

  static Future<Map<String, String?>> getUserInfo() async {
    final userID = await _storage.read(key: _keyUserID);
    final username = await _storage.read(key: _keyUsername);
    final email = await _storage.read(key: _keyEmail);
    final avatarUrl = await _storage.read(key: _keyAvatarUrl);
    final fullName = await _storage.read(key: _keyFullName);
    final token = await _storage.read(key: _keyToken);

    print('Reading from SecureStorage - userID: $userID, username: $username, fullName: $fullName, token: $token');

    return {
      'userID': userID,
      'username': username,
      'email': email,
      'avatarUrl': avatarUrl,
      'fullName': fullName,
      'token': token,
    };
  }

  static Future<void> clearUserInfo() async {
    await _storage.deleteAll();
  }
}