import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user_secure_storage.dart';
import 'provider/user_provider.dart';

Future<void> logoutUser(BuildContext context) async {
  await UserSecureStorage.clearUserInfo();

  Provider.of<UserProvider>(context, listen: false).clearUser();

  Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
}