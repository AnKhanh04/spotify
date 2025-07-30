import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '/services/provider/user_provider.dart';
import '/services/user_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _fullNameController = TextEditingController();
  String? _avatarUrl;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _fullNameController.text = userProvider.fullName ?? 'Minh Hoàng';
    _avatarUrl = userProvider.avatarUrl;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  Future<void> _saveChanges() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String newAvatarUrl = _avatarUrl ?? '';

    if (_selectedImagePath != null) {
      final imageUrl = await UserService.uploadImageToCloudinary(XFile(_selectedImagePath!));
      if (imageUrl != null) {
        newAvatarUrl = imageUrl;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lỗi khi upload ảnh')),
        );
        return;
      }
    }

    // Gọi API để cập nhật CSDL Railway
    final response = await http.put(
      Uri.parse('${UserService.baseUrl}/update-profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${userProvider.token}',
      },
      body: jsonEncode({
        'userId': userProvider.userID,
        'full_name': _fullNameController.text,
        'avatar_url': newAvatarUrl,
      }),
    );

    if (response.statusCode == 200) {
      // Cập nhật UserProvider sau khi API thành công
      userProvider.setUser(
        userProvider.userID ?? '',
        userProvider.userName ?? '',
        userProvider.email ?? '',
        newAvatarUrl,
        _fullNameController.text,
        userProvider.token ?? '',
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Hồ sơ đã được cập nhật')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi khi cập nhật hồ sơ')),
      );
      print('API Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Chỉnh sửa hồ sơ', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.pink,
                  backgroundImage: _selectedImagePath != null
                      ? FileImage(File(_selectedImagePath!)) as ImageProvider
                      : (_avatarUrl != null && _avatarUrl!.isNotEmpty
                      ? NetworkImage(_avatarUrl!)
                      : null),
                  child: _selectedImagePath == null && (_avatarUrl == null || _avatarUrl!.isEmpty)
                      ? Text(
                    _fullNameController.text.isNotEmpty
                        ? _fullNameController.text[0].toUpperCase()
                        : 'M',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                      : null,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Nhãn "Họ và tên" nằm trên TextField
            const Text(
              'Họ và tên',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8), // Khoảng cách giữa nhãn và TextField
            TextField(
              controller: _fullNameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                filled: true,
                fillColor: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text('Lưu thay đổi', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}