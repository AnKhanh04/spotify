import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../services/provider/user_provider.dart';

class PhoneSignUpScreen extends StatefulWidget {
  const PhoneSignUpScreen({super.key});

  @override
  State<PhoneSignUpScreen> createState() => _PhoneSignUpScreenState();
}

class _PhoneSignUpScreenState extends State<PhoneSignUpScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _usernameController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isOtpSent = false;
  bool _isOtpVerified = false;
  bool _isLoading = false;
  String? _apiError;

  // Focus nodes to manage keyboard focus
  final _otpFocus = FocusNode();
  final _usernameFocus = FocusNode();

  // API base URL
  final String _baseUrl = 'https://music-api-production-89f1.up.railway.app';

  // Validate phone number (VN format: +84 followed by 9 digits)
  bool _isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(r'^\+84\d{9}$');
    return phoneRegex.hasMatch(phone);
  }

  // Validate OTP (6 digits)
  bool _isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp);
  }

  // Validate user info
  bool _isValidUserInfo(String username, String password) {
    return username.isNotEmpty && password.isNotEmpty;
  }

  // Send OTP
  Future<void> _sendOtp() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';

    if (!_isValidPhoneNumber(phone)) {
      setState(() {
        _isLoading = false;
        _apiError = 'Vui lòng nhập số điện thoại hợp lệ (VD: +84987654321)';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/register-phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final otp = data['otp'];
        setState(() {
          _isOtpSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mã OTP là: $otp'),
            duration: const Duration(seconds: 10),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Lỗi gửi OTP';
        setState(() {
          _isLoading = false;
          _apiError = error;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi kết nối: $e';
      });
    }
  }

  // Verify OTP
  Future<void> _verifyOtp() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';
    final otp = _otpController.text.trim();

    if (!_isValidOtp(otp)) {
      setState(() {
        _isLoading = false;
        _apiError = 'Mã OTP phải là 6 chữ số';
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _isOtpVerified = true;
          _isLoading = false;
        });
        FocusScope.of(context).requestFocus(_usernameFocus);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'OTP xác minh thành công! Vui lòng nhập thông tin người dùng.',
            ),
            duration: Duration(seconds: 5),
          ),
        );
      } else {
        final error = jsonDecode(response.body)['error'] ?? 'Lỗi xác minh OTP';
        setState(() {
          _isLoading = false;
          _apiError = error;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi kết nối: $e';
      });
    }
  }

  // Submit user info
  Future<void> _submitUserInfo() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';
    final otp = _otpController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();

    if (!_isValidUserInfo(username, password)) {
      setState(() {
        _isLoading = false;
        _apiError = 'Vui lòng nhập username và password';
      });
      return;
    }

    // Create avatarUrl using UI Avatars
    final avatarName = fullName.isNotEmpty ? fullName : username;
    final avatarUrl =
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(avatarName)}';

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phone,
          'otp': otp,
          'username': username,
          'password': password,
          'full_name': fullName,
          'email': email,
          'avatar_url': avatarUrl,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        final token = data['token'];
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.setUser(
          user['username'],
          user['email'] ?? '',
          user['avatar_url'] ?? avatarUrl,
          // Use avatarUrl if not returned by API
          user['full_name'] ?? '',
          token,
        );

        Navigator.pushReplacementNamed(context, '/bottomnav');
      } else {
        final error =
            jsonDecode(response.body)['error'] ?? 'Lỗi đăng ký người dùng';
        setState(() {
          _isLoading = false;
          _apiError = error;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi kết nối: $e';
      });
    }
  }

  // Reset to phone input
  void _resetToPhoneInput() {
    setState(() {
      _isOtpSent = false;
      _isOtpVerified = false;
      _apiError = null;
      _otpController.clear();
      _usernameController.clear();
      _fullNameController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }

  // Resend OTP
  Future<void> _resendOtp() async {
    setState(() {
      _otpController.clear();
      _apiError = null;
    });
    await _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    print('Debug: _isOtpSent = $_isOtpSent, _isOtpVerified = $_isOtpVerified');
    return GestureDetector(
      // Ẩn bàn phím khi nhấn ra ngoài
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Đăng ký bằng số điện thoại')),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                enabled: !_isOtpSent,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixText: '+84',
                  hintText: 'Nhập số điện thoại',
                ),
              ),
              if (_isOtpSent && !_isOtpVerified) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 6,
                  focusNode: _otpFocus,
                  decoration: const InputDecoration(
                    labelText: 'Nhập mã OTP',
                    counterText: '',
                  ),
                  onSubmitted: (_) => _verifyOtp(),
                ),
              ],
              if (_isOtpVerified) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  focusNode: _usernameFocus,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    hintText: 'Nhập username',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _fullNameController,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                    labelText: 'Họ và tên',
                    hintText: 'Nhập họ và tên',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Nhập email',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Nhập Password',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              if (_apiError != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _apiError!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed:
                        _isLoading
                            ? null
                            : (_isOtpVerified
                                ? _submitUserInfo
                                : _isOtpSent
                                ? _verifyOtp
                                : _sendOtp),
                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                              _isOtpVerified
                                  ? 'Hoàn tất đăng ký'
                                  : _isOtpSent
                                  ? 'Xác minh OTP'
                                  : 'Gửi mã OTP',
                            ),
                  ),
                  if (_isOtpSent && !_isOtpVerified)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _resendOtp,
                      child: const Text('Gửi lại OTP'),
                    ),
                  if (_isOtpSent || _isOtpVerified)
                    OutlinedButton(
                      onPressed: _isLoading ? null : _resetToPhoneInput,
                      child: const Text('Sửa số điện thoại'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    _usernameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _otpFocus.dispose();
    _usernameFocus.dispose();
    super.dispose();
  }
}
