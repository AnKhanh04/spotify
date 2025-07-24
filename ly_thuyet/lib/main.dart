import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/configs/theme/app_theme.dart';
import 'presentation/splash/pages/splash_screen.dart';
import 'login_screen.dart';
import 'screens/signup_screen/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/search_screen.dart';
import 'header_bottom_nav/bottom.dart';
import 'screens/now_playing_screen.dart';
import 'screens/playlist_detail_screen.dart';
import 'screens/library_screen.dart';
import 'services/user_provider.dart';
import 'package:spotify/screens/phone_login_screen.dart';
import 'screens/signup_screen/signup_with_phone_screen.dart';
import 'screens/forgot_pass_screens/forgot_password_screen.dart';
import 'model/songs_model.dart';
import 'model/playlist_model.dart';

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
      onGenerateRoute: (settings) {
        if (settings.name == '/nowplaying') {
          final song = settings.arguments as Song;
          return MaterialPageRoute(
            builder: (context) => NowPlayingScreen(song: song),
          );
        }
        else if (settings.name == '/playlist') {
          final playlist = settings.arguments as Playlist;
          return MaterialPageRoute(
            builder: (context) => PlaylistDetailScreen(playlist: playlist),
          );
        }



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
        };

        final builder = routes[settings.name];
        if (builder != null) {
          return MaterialPageRoute(builder: builder);
        }

        return null;
      },
    );
  }
}