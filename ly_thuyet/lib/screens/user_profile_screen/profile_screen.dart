import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/provider/user_provider.dart';
import 'edit_profile_screen.dart'; // Import trang chỉnh sửa

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final fullName = userProvider.fullName ?? 'Minh Hoàng';
        final avatarUrl = userProvider.avatarUrl;

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: const [
              Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(Icons.more_horiz, color: Colors.white),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Căn trái cho avatar và nút chỉnh sửa
                children: [
                  const SizedBox(height: 20),
                  // Row chứa Avatar và thông tin bên phải
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.pink,
                        backgroundImage: avatarUrl != null && avatarUrl.isNotEmpty
                            ? NetworkImage(avatarUrl)
                            : null,
                        child: avatarUrl == null || avatarUrl.isEmpty
                            ? Text(
                          fullName.isNotEmpty ? fullName[0].toUpperCase() : 'M',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                            : null,
                      ),
                      const SizedBox(width: 16), // Khoảng cách giữa avatar và text
                      // Thông tin người dùng
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              fullName,
                              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              '0 người theo dõi • Đang theo dõi 0',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16), // Khoảng cách giữa avatar và nút chỉnh sửa
                  // Nút Chỉnh sửa nằm bên trái
                  Align(
                    alignment: Alignment.centerLeft, // Căn trái
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                      child: const Text('Chỉnh sửa'),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Nội dung dưới nút chỉnh sửa được căn giữa
                  Center(
                    child: Column(
                      children: [
                        const Text(
                          'Không có hoạt động gần đây.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Hãy khám phá thêm nhạc mới ngay',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}