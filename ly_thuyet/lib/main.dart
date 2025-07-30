import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/configs/theme/app_theme.dart';
import 'presentation/splash/pages/splash_screen.dart';
import 'screens/login_screens/login_screen.dart';
import 'screens/signup_screen/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen/search_screen.dart';
import 'header_bottom_nav/bottom.dart';
import 'screens/now_playing_screen.dart';
import 'screens/playlist_detail_screen.dart';
import 'screens/library_screen.dart';
import 'services/provider/user_provider.dart';
import 'services/provider/current_song_provider.dart';
import 'screens/login_screens/phone_login_screen.dart';
import 'screens/signup_screen/signup_with_phone_screen.dart';
import 'screens/forgot_pass_screens/forgot_password_screen.dart';
import 'model/songs_model.dart';
import 'model/playlist_model.dart';
import 'services/provider/favorite_provider.dart';
import 'screens/favorite_song_screen.dart';
import 'services/provider/recent_song_provider.dart';
import 'screens/premium_screen.dart';
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => CurrentSongProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => RecentSongsProvider()),
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
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final songProvider = Provider.of<CurrentSongProvider>(context, listen: false);

    await userProvider.loadUser();
    await songProvider.loadSavedSong(); // Load bài hát đã lưu

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
      onGenerateRoute: (settings) {
        // Route cho màn Now Playing
        if (settings.name == '/nowplaying') {
          final args = settings.arguments;
          if (args is Song) {
            return MaterialPageRoute(
              builder: (context) => NowPlayingScreen(song: args),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Không có bài hát để phát")),
              ),
            );
          }
        }

        // Route cho playlist
        if (settings.name == '/playlist') {
          final args = settings.arguments;
          if (args is Playlist) {
            return MaterialPageRoute(
              builder: (context) => PlaylistDetailScreen(playlist: args),
            );
          } else {
            return MaterialPageRoute(
              builder: (_) => const Scaffold(
                body: Center(child: Text("Không tìm thấy playlist")),
              ),
            );
          }
        }

        // Các route còn lại
        final routes = <String, WidgetBuilder>{
          '/sign-up-phone': (context) => const PhoneSignUpScreen(),
          '/phone-login': (context) => const PhoneLoginScreen(),
          '/login': (context) => const LoginScreen(),
          '/forgotpass': (context) => const ForgotPasswordScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/bottomnav': (context) => const BottomNav(),
          '/home': (context) => const HomeScreen(),
          '/search': (context) => const SearchScreen(),
          '/library': (context) => const LibraryScreen(),
          '/favorites': (context) => const FavoriteSongsScreen(),
          '/premium': (context) => const PremiumScreen(),

        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        // Nếu route không tồn tại
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text("404 - Không tìm thấy trang")),
          ),
        );
      },
    );
  }
}
