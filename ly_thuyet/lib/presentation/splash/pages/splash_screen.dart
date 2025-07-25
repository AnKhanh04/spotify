import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:spotify/core/configs/assets/app_vectors.dart';
import 'package:spotify/services/user_secure_storage.dart';
import 'package:spotify/services/provider/user_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final userInfo = await UserSecureStorage.getUserInfo();
    final token = userInfo['token'];

    await Future.delayed(const Duration(seconds: 2));

    if (token != null && token.isNotEmpty) {
      Navigator.pushReplacementNamed(context, '/bottomnav');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/vectors/logo_spotify_splash.png',
          width: 200,
        ),
      ),
    );
  }
}
