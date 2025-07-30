import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Premium',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Text(
              'Quay lại với Premium:\nDùng thử miễn phí Premium Individual trong 1 tháng.',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Bạn không thể nâng cấp lên Premium trong ứng dụng này. Chúng tôi biết điều này thật bất tiện.',
              style: TextStyle(color: Colors.white54),
            ),
            const SizedBox(height: 20),

            // Individual Plan
            _buildPlanCard(
              title: 'Individual',
              subtitle:
              '1 tài khoản Premium\nHủy bất cứ lúc nào\nĐăng ký hoặc thanh toán một lần',
              badgeText: 'Miễn phí trong 1 tháng',
            ),

            const SizedBox(height: 16),

            // Student Plan
            _buildPlanCard(
              title: 'Student',
              subtitle:
              '1 tài khoản Premium đã xác minh\nGiảm giá cho sinh viên đủ điều kiện\nHủy bất cứ lúc nào\nĐăng ký hoặc thanh toán một lần',
            ),

            const SizedBox(height: 20),

            // Reasons Section in Card
            _buildPlanCard(
              title: 'Lý do nên dùng gói Premium',
              children: [
                _buildReason(Icons.music_off, 'Nghe nhạc không quảng cáo'),
                _buildReason(Icons.download, 'Tải xuống để nghe không cần mạng'),
                _buildReason(Icons.queue_music, 'Phát nhạc theo thứ tự bất kỳ'),
                _buildReason(Icons.high_quality, 'Chất lượng âm thanh cao'),
                _buildReason(Icons.group, 'Nghe cùng bạn bè theo thời gian thực'),
                _buildReason(Icons.playlist_play, 'Sắp xếp danh sách chờ nghe'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPlanCard({
    required String title,
    String? subtitle,
    String? badgeText,
    List<Widget>? children,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (badgeText != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                badgeText,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(color: Colors.white70),
            ),
          ],
          if (children != null) ...[
            const SizedBox(height: 12),
            ...children,
          ],
        ],
      ),
    );
  }

  static Widget _buildReason(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
