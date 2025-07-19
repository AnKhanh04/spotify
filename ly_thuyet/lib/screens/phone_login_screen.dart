import 'package:flutter/material.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();
  bool _isOtpSent = false;

  Future<void> _sendOtp() async {
    // Gọi API gửi OTP
    final phone = _phoneController.text.trim();
    if (phone.isNotEmpty) {
      // TODO: Gọi API gửi mã OTP
      print('Gửi OTP đến: $phone');
      setState(() {
        _isOtpSent = true;
      });
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();
    // TODO: Gọi API xác minh mã OTP
    if (otp == "123456") {
      // Giả sử đúng
      print('OTP đúng, đăng nhập thành công');
      // TODO: Lưu thông tin người dùng vào Provider + SharedPreferences
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print('Mã OTP không đúng');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng nhập bằng số điện thoại')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            if (_isOtpSent)
              TextField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'Nhập mã OTP'),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isOtpSent ? _verifyOtp : _sendOtp,
              child: Text(_isOtpSent ? 'Xác minh OTP' : 'Gửi mã OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
