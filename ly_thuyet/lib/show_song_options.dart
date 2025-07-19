import 'package:flutter/material.dart';

void showSongOptions(BuildContext context) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.grey[900],
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          runSpacing: 8,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            ListTile(
              leading: Image.network(
                'https://via.placeholder.com/50',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
              title: const Text('Từng Ngày Yêu Em', style: TextStyle(color: Colors.white)),
              subtitle: const Text('buitruonglinh • Từng Ngày Như Mãi Mãi', style: TextStyle(color: Colors.white54)),
            ),
            const Divider(color: Colors.white12),

            _option(icon: Icons.share, title: 'Chia sẻ'),
            _option(icon: Icons.workspace_premium, title: 'Nghe nhạc không quảng cáo', trailing: const Text('Premium', style: TextStyle(color: Colors.green))),
            _option(icon: Icons.favorite_border, title: 'Thêm vào Bài hát ưa thích'),
            _option(icon: Icons.playlist_add, title: 'Thêm vào danh sách phát'),
            _option(icon: Icons.hide_source, title: 'Ẩn trong danh sách phát này'),
            _option(icon: Icons.radio, title: 'Truy cập radio'),
            _option(icon: Icons.album, title: 'Chuyển đến album'),
            _option(icon: Icons.person, title: 'Chuyển tới trang nghệ sĩ'),
            _option(icon: Icons.event, title: 'Chuyển đến buổi biểu diễn của nghệ sĩ'),
            _option(icon: Icons.info_outline, title: 'Xem thông tin ghi công của bài hát'),
            _option(icon: Icons.timer, title: 'Hẹn giờ đi ngủ'),
            _option(icon: Icons.qr_code, title: 'Hiển thị mã Spotify', trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white38, size: 16)),
          ],
        ),
      );
    },
  );
}

Widget _option({required IconData icon, required String title, Widget? trailing}) {
  return ListTile(
    leading: Icon(icon, color: Colors.white),
    title: Text(title, style: const TextStyle(color: Colors.white)),
    trailing: trailing,
    onTap: () {
      // Tùy chỉnh hành động nếu cần
    },
  );
}
