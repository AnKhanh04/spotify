import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:spotify/services/provider/user_provider.dart';
import 'package:spotify/services/user_secure_storage.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;
  bool _isLoading = false;
  String? _apiError;

  final _otpFocus = FocusNode();

  final String _baseUrl = 'https://music-api-production-89f1.up.railway.app';

  bool _isValidPhoneNumber(String phone) {
    final RegExp phoneRegex = RegExp(r'^\+84\d{9,10}$');
    return phoneRegex.hasMatch(phone);
  }

  bool _isValidOtp(String otp) {
    return otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp);
  }

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
        _apiError = 'Vui lòng nhập số điện thoại hợp lệ';
      });
      return;
    }

    try {
      print('DEBUG: Sending OTP request to $_baseUrl/login-phone with phone: $phone');
      final response = await http.post(
        Uri.parse('$_baseUrl/login-phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
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
        final errorData = jsonDecode(response.body);
        final error = errorData['error'] ?? 'Lỗi không xác định từ server (Mã: ${response.statusCode}, Body: ${response.body})';
        setState(() {
          _isLoading = false;
          _apiError = error;
        });
      }
    } catch (e) {
      print('DEBUG: Error in _sendOtp: $e');
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi kết nối: $e';
      });
    }
  }

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
      print('DEBUG: Verifying OTP for phone: $phone with OTP: $otp');
      final response = await http.post(
        Uri.parse('$_baseUrl/verify-otp-login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      print('DEBUG: Response status: ${response.statusCode}');
      print('DEBUG: Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final user = data['user'];
        final token = data['token'];
        final username = user['username'] ?? 'unknown_user';
        final email = user['email'] ?? '';
        final fullName = user['full_name'] ?? 'No Name';
        final avatarUrl = user['avatar_url'] ?? // Lấy từ API
            'https://ui-avatars.com/api/?name=${Uri.encodeComponent(username)}'; // Fallback

        print('DEBUG: Avatar URL: $avatarUrl'); // Log để kiểm tra avatar

        final userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(username, email, avatarUrl, fullName, token);

        await UserSecureStorage.setUserInfo(
          username: username,
          email: email,
          avatarUrl: avatarUrl,
          fullName: fullName,
          token: token,
        );

        Navigator.pushReplacementNamed(context, '/bottomnav');
      } else {
        final errorData = jsonDecode(response.body);
        final error = errorData['error'] ?? 'Lỗi xác minh OTP (Mã: ${response.statusCode})';
        setState(() {
          _isLoading = false;
          _apiError = error;
        });
      }
    } catch (e) {
      print('DEBUG: Error in _verifyOtp: $e');
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi kết nối: $e';
      });
    }
  }

  void _resetToPhoneInput() {
    setState(() {
      _isOtpSent = false;
      _apiError = null;
      _otpController.clear();
    });
  }

  Future<void> _resendOtp() async {
    setState(() {
      _otpController.clear();
      _apiError = null;
    });
    await _sendOtp();
  }

  @override
  Widget build(BuildContext context) {
    print('Debug: _isOtpSent = $_isOtpSent, _isLoading = $_isLoading');
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập bằng số điện thoại')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
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
                ),
              ),
              if (_isOtpSent) ...[
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
                    onPressed: _isLoading
                        ? null
                        : (_isOtpSent ? _verifyOtp : _sendOtp),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : Text(_isOtpSent ? 'Xác minh OTP' : 'Gửi mã OTP'),
                  ),
                  if (_isOtpSent)
                    ElevatedButton(
                      onPressed: _isLoading ? null : _resendOtp,
                      child: const Text('Gửi lại OTP'),
                    ),
                  if (_isOtpSent)
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
    _otpFocus.dispose();
    super.dispose();
  }
}