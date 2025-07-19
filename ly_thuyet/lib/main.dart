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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
      routes: {
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
