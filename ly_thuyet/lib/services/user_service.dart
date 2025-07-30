import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserService {
  static const String baseUrl = 'https://music-api-production-89f1.up.railway.app/users';
  static const String cloudinaryUploadUrl = 'https://api.cloudinary.com/v1_1/dpaobwox0/image/upload'; // Thay cloud name
  static const String uploadPreset = 'your_upload_preset'; // Thay bằng upload preset của bạn

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
    final url = Uri.parse('$baseUrl/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<String?> uploadImageToCloudinary(XFile imageFile) async {
    var request = http.MultipartRequest('POST', Uri.parse(cloudinaryUploadUrl));
    request.files.add(await http.MultipartFile.fromPath('file', imageFile.path));
    request.fields['upload_preset'] = uploadPreset;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var jsonResponse = jsonDecode(responseData);
        return jsonResponse['secure_url']; // Trả về URL từ Cloudinary
      } else {
        print('Upload failed with status: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  static Future<void> updateProfile(String token, String avatarUrl, String fullName) async {
    final url = Uri.parse('$baseUrl/update-profile');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'avatarUrl': avatarUrl, 'fullName': fullName}),
    );
    if (response.statusCode != 200) {
      print('Failed to update profile: ${response.statusCode} - ${response.body}');
    }
  }
}