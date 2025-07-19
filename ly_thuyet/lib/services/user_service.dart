import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  static const String baseUrl = 'https://music-api-production-89f1.up.railway.app/users';

  static Future<bool> registerUser(String fullname, String username, String email, String password) async {
    final avatarUrl = 'https://ui-avatars.com/api/?name=${Uri.encodeComponent(username)}';

    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'full_name': fullname,
        'username': username,
        'email': email,
        'password': password,
        'avatar_url': avatarUrl,
      }),
    );

    return response.statusCode >= 200 && response.statusCode < 300;
  }

  static Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    final url = Uri.parse('https://music-api-production-89f1.up.railway.app/users/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }
}
