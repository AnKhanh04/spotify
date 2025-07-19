import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../login_screen.dart';
import '../services/user_provider.dart';
import '../services/user_secure_storage.dart'; // Đừng quên import phần này

class AvatarDrawer extends StatelessWidget {
  const AvatarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();
    final fullName = userProvider.fullName;
    final avatarUrl = userProvider.avatarUrl;

    return Drawer(
      backgroundColor: Colors.black,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.black),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey[800],
                  backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: (avatarUrl == null || avatarUrl.isEmpty)
                      ? const Icon(Icons.person, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Xin chào, ${fullName != null && fullName.trim().isNotEmpty ? fullName : 'Người dùng'}',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await UserSecureStorage.clearUserInfo(); // Xóa dữ liệu lưu trữ an toàn
              userProvider.clearUser(); // Xóa dữ liệu bộ nhớ (RAM)

              // Điều hướng quay lại màn hình đăng nhập và xóa toàn bộ history
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
