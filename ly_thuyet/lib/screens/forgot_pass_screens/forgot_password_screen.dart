import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  bool _isLoading = false;
  String? _apiError;

  final _otpFocus = FocusNode();

  final String _baseUrl = 'https://music-api-production-89f1.up.railway.app';

  bool _isValidPhoneNumber(String phone) => RegExp(r'^\+84\d{9}$').hasMatch(phone);
  bool _isValidOtp(String otp) => otp.length == 6 && RegExp(r'^\d+$').hasMatch(otp);

  Future<void> _sendOtp() async {
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';
    if (!_isValidPhoneNumber(phone)) {
      setState(() {
        _isLoading = false;
        _apiError = 'Số điện thoại không hợp lệ (+84xxxxxxxxx)';
      });
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          _otpSent = true;
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('OTP đã được gửi: ${data["otp"] ?? "(ẩn)"}')),
        );
      } else {
        setState(() {
          _isLoading = false;
          _apiError = data['error'] ?? 'Không gửi được OTP';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi: $e';
      });
    }
  }

  Future<void> _verifyOtp() async {
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';
    final otp = _otpController.text.trim();

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'otp': otp}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        setState(() {
          _otpVerified = true;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
          _apiError = data['error'] ?? 'Xác minh OTP thất bại';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi: $e';
      });
    }
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
      _apiError = null;
    });

    final phone = '+84${_phoneController.text.trim()}';
    final password = _passwordController.text.trim();

    if (password.isEmpty || password.length < 6) {
      setState(() {
        _isLoading = false;
        _apiError = 'Mật khẩu phải từ 6 ký tự';
      });
      return;
    }

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/update-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phone, 'newPassword': password}),
      );

      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cập nhật mật khẩu thành công!')),
        );
        Navigator.pop(context);
      } else {
        setState(() {
          _isLoading = false;
          _apiError = data['error'] ?? 'Không cập nhật được mật khẩu';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _apiError = 'Lỗi: $e';
      });
    }
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: hintText,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quên mật khẩu')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              enabled: !_otpSent,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                prefixText: '+84',
                hintText: 'Nhập số điện thoại',
              ),
            ),
            if (_otpSent && !_otpVerified) ...[
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
            if (_otpVerified) ...[
              const SizedBox(height: 16),
              _buildInputField(
                controller: _passwordController,
                hintText: 'Mật khẩu mới',
                obscureText: true,
              ),
            ],
            const SizedBox(height: 20),
            if (_apiError != null)
              Text(_apiError!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            _buildButton(
              _otpVerified
                  ? 'Cập nhật mật khẩu'
                  : _otpSent
                  ? 'Xác minh OTP'
                  : 'Gửi mã OTP',
              _otpVerified
                  ? _updatePassword
                  : _otpSent
                  ? _verifyOtp
                  : _sendOtp,
            ),
          ],
        ),
      ),
    );
  }
}
