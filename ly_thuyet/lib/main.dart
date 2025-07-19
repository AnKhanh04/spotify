import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/configs/theme/app_theme.dart';
import 'presentation/splash/pages/splash_screen.dart';
import 'login_screen.dart';
import 'signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'header_bottom_nav/bottom.dart';
import 'screens/now_playing_screen.dart';
import 'screens/playlist_detail_screen.dart';
import 'screens/library_screen.dart';
import 'services/user_provider.dart';
import 'package:spotify/screens/phone_login_screen.dart'; // Thêm import

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeUser();
  }

  Future<void> _initializeUser() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadUser();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    if (_isLoading) {
      return const MaterialApp(
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: userProvider.isLoggedIn ? const BottomNav() : const LoginScreen(),
      routes: {
        '/phone-login': (context) => const PhoneLoginScreen(), // Thêm route
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/bottomnav': (context) => const BottomNav(),
        '/home': (context) => const HomeScreen(),
        '/search': (context) => const SearchScreen(),
        '/library': (context) => const LibraryScreen(),
        '/nowplaying': (context) => const NowPlayingScreen(),
        '/playlist': (context) => const PlaylistDetailScreen(),
      },
    );
  }
}