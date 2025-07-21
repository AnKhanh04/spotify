import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spotify/screens/signup_screen/signup_options_screen.dart';
import '../services/user_service.dart';
import '../services/user_provider.dart';
import '../services/user_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../screens/phone_login_screen.dart';
import 'screens/forgot_pass_screens/forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ email và mật khẩu')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final result = await UserService.loginUser(email, password);

    setState(() {
      _isLoading = false;
    });

    if (result != null) {
      final username = result['username'] ?? 'unknown_user';
      final fullName = result['full_name'] ?? 'No Name';
      final token = result['token'] ?? ''; // ← Lấy token từ kết quả API
      final avatarUrl =
          result['avatarUrl'] ??
          'https://ui-avatars.com/api/?name=${Uri.encodeComponent(username)}';

      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setUser(username, email, avatarUrl, fullName, token);

      await UserSecureStorage.setUserInfo(
        username: username,
        email: email,
        avatarUrl: avatarUrl,
        fullName: fullName,
        token: token, // ← Lưu token vào storage
      );

      Provider.of<UserProvider>(
        context,
        listen: false,
      ).setUser(username, email, avatarUrl, fullName, token);

      Navigator.pushReplacementNamed(context, '/bottomnav');
    }
  }

  Future<void> loginWithGoogle() async {
    final googleSignIn = GoogleSignIn();

    try {
      final account = await googleSignIn.signIn();

      if (account != null) {
        final email = account.email;
        final name = account.displayName ?? 'No Name';
        final avatarUrl =
            account.photoUrl ??
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(name)}';

        // Nếu có backend xác thực thì gọi API tại đây

        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(name, email, avatarUrl, name, '');

        await UserSecureStorage.setUserInfo(
          username: name,
          email: email,
          avatarUrl: avatarUrl,
          fullName: name,
          token: '',
        );

        Navigator.pushReplacementNamed(context, '/bottomnav');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập Google thất bại')),
        );
      }
    } catch (e) {
      print('Google Sign-In error: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lỗi đăng nhập Google')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Ẩn bàn phím khi nhấn ra ngoài
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.black,
        resizeToAvoidBottomInset: true,
        // đảm bảo layout co lại khi bàn phím hiện
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                // thêm khoảng cách trên cùng
                Image.asset(
                  'assets/vectors/logo_spotify_login.png',
                  width: 220,
                ),

                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    hintText: 'Mật khẩu',
                    hintStyle: const TextStyle(color: Colors.white54),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _loginUser,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Đăng nhập',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 20),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Quên mật khẩu',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),

                const SizedBox(height: 12),

                const Text(
                  'Hoặc đăng nhập bằng',
                  style: TextStyle(color: Colors.white54),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Image.asset('assets/icons/logo_gg.png', height: 50),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        // TODO: Gọi hàm đăng nhập bằng Facebook
                      },
                      icon: Image.asset('assets/icons/logo_fb.png', height: 50),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PhoneLoginScreen(),
                          ),
                        );
                      },
                      icon: Image.asset(
                        'assets/icons/logo_phone.png',
                        height: 50,
                      ),
                    ),
                  ],
                ),

                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignupOptionsScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Chưa có tài khoản? Đăng ký',
                    style: TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
